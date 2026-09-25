# AGENTS.md — AI Agent Onboarding & Operating Instructions

This document is the authoritative instruction manual for any AI coding assistant (Claude Code, Antigravity, Codex, Aider, Cursor, etc.) operating on the `morfin` codebase. Read this document before inspecting files or writing code.

---

## 1. Fast Context
- **Project**: `morfin`
- **Role**: Native Android specialist writing production-grade, maintainable, modular, and performant code.
- **Target Platform**: **Android only**. Do not add cross-platform shims, iOS code, or redundant platform checks.
- **Framework**: Flutter 3.13+ (Dart 3.x), Material Design 3 (M3), Riverpod state management.
- **Architecture**: **Server-Driven UI (SDUI)** consuming **OData v4 REST projections** (IFS Cloud compatible). Strict MVVM with Unidirectional Data Flow (UDF).
- **Mode**: **Always-Online**. Master data and transactions are never cached locally. Offline queues are strictly forbidden.
- **Branding Rule**: Keep internal code vendor-neutral (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`, `EntitySchemaRegistry`). Do NOT introduce `ifs_` prefixes into class names, file names, or variable identifiers.

---

## 2. Hard Invariants & Red Lines

| Rule | Constraint | Enforcement / Failure Mode |
| :--- | :--- | :--- |
| **Max File Length** | **<180 lines** (soft), **<200 lines** (hard) | Split large widgets into subcomponents inside `components/` or separate files. Zero God Objects. |
| **Command Prefix** | Mandatory `rtk` prefix (`rtk cli ai`) | Always prepend `rtk` to commands: `rtk dart analyze lib test`, `rtk flutter test`, `rtk git ...` |
| **Platform Target** | Android only | Never write iOS specific configuration, Objective-C/Swift pods, or multiplatform branching. |
| **Testing Rule** | No unsolicited tests | Do NOT generate test suites, unit tests, or instrumentation tests unless explicitly instructed. |
| **Online First** | Zero offline transactional mutations | Never implement local SQLite/Hive offline sync queues. API errors must propagate to UI. |
| **UI Aesthetics** | Material Design 3 + `antislop-ui` | Clean, deterministic layouts. Eliminate bloated wrappers, placeholders, and decorative UI slop. First-class Light & Dark themes. |
| **Static Analysis** | 0 warnings, 0 errors | Must verify with `rtk dart analyze lib test` before finishing turns. |
| **Test Verification** | 100% test pass rate | Verify existing tests with `rtk flutter test`. |

---

## 3. Graphify Topological Architecture

The codebase has been mapped using Graphify AST analysis (**811 nodes, 1,155 edges, 56 communities**).
Key architectural hubs:

```
[LocalStorageService] ──> [ServerConfig] <──> [ApiConfig]
                                                    │
                                                    ▼
[EntityListScreen] <── [ErpCloudService] <── [ApiClient] <── [AuthInterceptor]
          │
          ├──> [EntityCard]
          │
          └──> [AppActionDispatcher] ──> [EntityActionSheet]
```

### Top Architectural Hubs (God Nodes)
| Rank | Architectural Node | Type | Connected Edges | Role |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `LoginAction` | Sealed Class | 10 | Action contracts driving authentication and server selection |
| 2 | `SettingsAction` | Sealed Class | 9 | Global theme and application configuration events |
| 3 | `LobbyElementMetadata` | Contract | 7 | Dynamic layout and data definition for Lobby dashboard tiles |
| 4 | `ServerConfig` | Data Model | 7 | OData endpoint credentials, URLs, and realm definitions |
| 5 | `LoginState` | State Model | 6 | Reactive authentication and active server selection state |
| 6 | `EntitySchemaMetadata` | Contract | 5 | SDUI schema definition for dynamic entity sets, cards, and actions |
| 7 | `localStorageServiceProvider` | Provider | 5 | Persists user preferences and server profiles |
| 8 | `NotificationsAction` | Sealed Class | 5 | System alert and push event contracts |
| 9 | `themeModeProvider` | Provider | 5 | Reactive theme mode state provider |
| 10 | `ActionMetadata` | Contract | 4 | Standardized contract for UI actions and navigation triggers |

### Key File Index
- `lib/core/network/api_config.dart`: Global singleton managing active server URL, realm, and OAuth tokens.
- `lib/core/network/api_client.dart`: Dio-based HTTP client executing OData v4 operations (`getEntitySet`, `getEntity`, `postEntity`, `patchEntity`, `callAction`).
- `lib/core/network/auth_interceptor.dart`: Auto-injects bearer token; transparently triggers `refreshTokenOAuth()` upon receiving HTTP 401.
- `lib/core/network/odata_query.dart`: Fluent builder for OData query strings (`$filter`, `$select`, `$top`, etc.).
- `lib/core/services/erp_cloud_service.dart`: Generic OData projection gateway (`fetchEntitySet`, `fetchEntityRecord`, `createEntityRecord`, `updateEntityRecord`, `executeAction`).
- `lib/core/metadata/entity_schema_registry.dart`: Central registry of SDUI entity schemas with target route mapping.
- `lib/core/metadata/`: SDUI contracts (`EntitySchemaMetadata`, `ActionMetadata`, `LobbyPageMetadata`, `MenuMetadata`).
- `lib/core/navigation/action_dispatcher.dart`: Central dispatcher executing schema-driven SDUI navigation and modal actions.
- `lib/core/storage/local_storage_service.dart`: SharedPreferences persistence for server profiles, selected server ID, and theme.
- `lib/core/widgets/entity/`: Pure SDUI entity components (`EntityListScreen`, `EntityDetailScreen`, `EntityCard`, `EntityActionSheet`, `EntityFormField`).
- `lib/core/widgets/lobby/`: Dynamic dashboard tiles (`LobbyGrid`, `LobbyElementTile`, `LobbyCounterTile`, `LobbyChartTile`, etc.).
- `lib/core/widgets/menu/`: Dynamic menu navigation (`MenuSectionCard`, `MenuItemTile`).
- `lib/features/login/models/server_config.dart`: Profile model defining server URL, realm, and OAuth client credentials.

---

## 4. How-To Recipes for AI Agents

### Recipe A: Adding a New Entity to the App (Pure SDUI)
1. **Define Schema**: Register an `EntitySchemaMetadata` inside `lib/core/metadata/entity_schema_registry.dart` declaring:
   - `projection`: Backend OData projection name (e.g., `CustomerOrderHandling`).
   - `entitySet`: Backend entity set name (e.g., `CustomerOrderSet`).
   - `fields`: Keys, labels, data types, and required flags.
   - `listCard`: Field mappings for the dynamic `EntityCard`.
   - `actions`: Global and record-level actions (e.g. `Release`, `Cancel`).
2. **Register Route Key**: Add the alias key to `EntitySchemaRegistry.findByTarget(target)`.
3. **Done!**: No custom screens, viewmodels, or mock files needed. `EntityListScreen`, `EntityCard`, `EntityDetailScreen`, and `EntityActionSheet` automatically render and execute live OData mutations.
4. **Line Count Guard**: Ensure neither file exceeds 180 lines.

### Recipe B: Modifying or Adding a Server Profile Field
1. Update `lib/features/login/models/server_config.dart` (`toJson`, `fromJson`, constructor).
2. Update `lib/features/login/server_form_screen.dart` to add the form field and validation.
3. Keep the file strictly under 180 lines.

### Recipe C: Adding a New Lobby Tile Type
1. Add enum value to `LobbyElementType` in `lib/core/metadata/lobby_metadata.dart`.
2. Implement widget under `lib/core/widgets/lobby/lobby_<type>_tile.dart`.
3. Register the widget in `lib/core/widgets/lobby/lobby_element_tile.dart`.

---

## 5. Verification Protocol
Always run the following commands sequentially before completing any coding task:
```bash
rtk dart analyze lib test
rtk flutter test
```
If working with Git:
```bash
rtk git status
rtk git add <files>
rtk git commit -m "<concise message>"
```
