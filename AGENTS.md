# AGENTS.md — AI Agent Onboarding & Operating Instructions

This document is the authoritative instruction manual for any AI coding assistant (Claude Code, Antigravity, Codex, Aider, Cursor, etc.) operating on the `morfin` codebase. Read this document before inspecting files or writing code.

---

## 1. Fast Context
- **Project**: `morfin`
- **Role**: Native Android specialist writing production-grade, maintainable, modular, and performant code.
- **Target Platform**: **Android only**. Do not add cross-platform shims, iOS code, or redundant platform checks.
- **Framework**: Flutter 3.13+ (Dart 3.x), Material Design 3 (M3), Riverpod state management.
- **Architecture**: **Server-Driven UI (SDUI)** consuming **Enterprise REST projections** (IFS Cloud compatible). Strict MVVM with Unidirectional Data Flow (UDF).
- **Mode**: **Always-Online**. Master data and transactions are never cached locally. Offline queues are strictly forbidden.
- **Branding & Naming Rule**: Keep code vendor-neutral and professional (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `BackendService`, `RecordSchemaRegistry`, `RecordFieldMetadata`, `RecordFormScreen`). Avoid legacy prefixes (`ifs_`) or informal colloquialisms (`mobile`, `odata`, `entity` when referring to generic records).

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
| **Static Analysis** | 0 warnings, 0 errors in `lib/` | Must verify with `rtk dart analyze lib test` before finishing turns. |
| **Test Verification** | 100% test pass rate | Verify existing tests with `rtk flutter test`. |

---

## 3. Graphify Topological Architecture

The codebase has been mapped using Graphify AST analysis (**1,068 nodes, 1,443 edges**).
Key architectural hubs:

```
[LocalStorageService] ──> [ServerConfig] <──> [ApiConfig]
                                                    │
                                                    ▼
[RecordListScreen] <── [BackendService] <── [ApiClient] <── [AuthInterceptor]
          │
          ├──> [RecordCard]
          │
          └──> [ActionDispatcher] ──> [RecordActionSheet]
                                           │
                                           └──> [RecordFormScreen]
```

### Top Architectural Hubs (God Nodes)
| Rank | Architectural Node | Type | Connected Edges | Role |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `LoginAction` | Sealed Class | 10 | Action contracts driving authentication and server selection |
| 2 | `ServerConfig` | Data Model | 7 | Endpoint credentials, URLs, and realm definitions |
| 3 | `LobbyElementMetadata` | Contract | 6 | Dynamic layout and data definition for Lobby dashboard tiles |
| 4 | `LoginState` | State Model | 6 | Reactive authentication and active server selection state |
| 5 | `userProfileProvider` | Provider | 5 | Live user profile data provider from FrameworkServices |
| 6 | `localStorageServiceProvider` | Provider | 5 | Persists user preferences and server profiles |
| 7 | `SettingsAction` | Sealed Class | 5 | Global theme and application configuration events |
| 8 | `ActionMetadata` | Contract | 4 | Standardized contract for UI actions and navigation triggers |
| 9 | `RecordSchemaMetadata` | Contract | 4 | SDUI schema definition for dynamic endpoints, cards, and actions |
| 10 | `ThemeModeNotifier` | Notifier / State | 4 | Reactive theme mode state management |

### Key File Index
- `lib/core/network/api_config.dart`: Global singleton managing active server URL, realm, and OAuth tokens.
- `lib/core/network/api_client.dart`: Dio-based HTTP client executing REST projection operations (`getCollection`, `getRecord`, `postRecord`, `patchRecord`, `callAction`).
- `lib/core/network/auth_interceptor.dart`: Auto-injects bearer token; transparently triggers `refreshTokenOAuth()` upon receiving HTTP 401.
- `lib/core/network/activity_log_interceptor.dart`: Dio interceptor recording live request/response telemetry for diagnostics.
- `lib/core/network/data_query.dart`: Fluent builder for query strings (`$filter`, `$select`, `$top`, etc.).
- `lib/core/services/backend_service.dart`: Core backend integration gateway (`fetchCollection`, `fetchRecord`, `createRecord`, `updateRecord`, `executeAction`, `executeBatchAction`, `fetchNavigatorNodes`).
- `lib/core/services/schema_catalog_service.dart`: Live projection schema discovery & XML metadata introspection service (`fetchKeyFields`).
- `lib/core/services/cache_manager_service.dart`: Live cache size calculation and cache clearing service.
- `lib/core/services/activity_log_service.dart`: In-memory network and system activity logger for diagnostics export.
- `lib/core/providers/user_profile_provider.dart`: Fetches live user profile data via `FrameworkServices.svc/GetCurrentUserInformation()`.
- `lib/core/metadata/record_schema_registry.dart`: Central registry of SDUI record schemas with target route mapping.
- `lib/core/metadata/record_metadata.dart`: SDUI contracts (`RecordSchemaMetadata`, `RecordFieldMetadata`, `RecordActionMetadata`, `RecordListCardMetadata`).
- `lib/core/metadata/`: SDUI contracts (`ActionMetadata`, `LobbyPageMetadata`, `MenuMetadata`).
- `lib/core/navigation/action_dispatcher.dart`: Central dispatcher executing schema-driven SDUI navigation and modal actions.
- `lib/core/storage/local_storage_service.dart`: SharedPreferences persistence for server profiles, selected server ID, and theme.
- `lib/core/utils/payload_utils.dart`: Sanitizes payloads, formats numeric and nested line-item values, and extracts human-readable response messages.
- `lib/core/utils/action_metadata_loader.dart`: Dynamically introspects and parses action parameter schemas.
- `lib/core/utils/action_field_consolidator.dart`: Merges dot-notated array fields, resolves LOV projections, and builds complete schema definitions.
- `lib/core/utils/param_config_parser.dart`: Robust parser for action parameter config strings.
- `lib/core/utils/record_lookup_loader.dart`: Dynamically loads and filters LOV records using key fields and form context.
- `lib/core/widgets/record/`: Pure SDUI record components (`RecordListScreen`, `RecordDetailScreen`, `RecordCard`, `RecordActionSheet`, `RecordFormScreen`, `RecordFormField`, `RecordArrayField`, `RecordLookupSheet`, `RecordFormDiscardDialog`).
- `lib/core/widgets/lobby/`: Dynamic dashboard tiles (`LobbyGrid`, `LobbyElementTile`, `LobbyCounterTile`, `LobbyChartTile`, etc.).
- `lib/core/widgets/menu/`: Dynamic menu navigation (`MenuSectionCard`, `MenuItemTile`).
- `lib/features/login/models/server_config.dart`: Profile model defining server URL, realm, and OAuth client credentials.
- `lib/features/shell/main_shell_screen.dart`: 3-tab navigation shell (Lobby, Menu, Settings).

---

## 4. How-To Recipes for AI Agents

### Recipe A: Adding a New Record Schema to the App (Pure SDUI)
1. **Define Schema**: Register a `RecordSchemaMetadata` inside `lib/core/metadata/record_schema_registry.dart` declaring:
   - `projection`: Backend projection name (e.g., `CustomerOrderHandling`).
   - `entitySet`: Backend endpoint/set name (e.g., `CustomerOrderSet`).
   - `fields`: Keys, labels, data types, and required flags.
   - `listCard`: Field mappings for the dynamic `RecordCard`.
   - `actions`: Global and record-level actions (e.g. `Release`, `Cancel`).
2. **Register Route Key**: Add the alias key to `RecordSchemaRegistry.findByTarget(target)`.
3. **Done!**: No custom screens, viewmodels, or mock files needed. `RecordListScreen`, `RecordCard`, `RecordDetailScreen`, `RecordActionSheet`, and `RecordFormScreen` automatically render and execute live backend mutations.
4. **Line Count Guard**: Ensure every file remains strictly under 180 lines.

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
