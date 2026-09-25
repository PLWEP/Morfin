# AGENTS.md — AI Agent Onboarding & Operating Instructions

This document is the authoritative instruction manual for any AI coding assistant (Claude Code, Antigravity, Codex, Aider, Cursor, etc.) operating on the `morfin` codebase. Read this document before inspecting files or writing code.

---

## 1. Fast Context
- **Project**: `morfin`
- **Framework**: Flutter 3.13+ (Dart 3.x), Material 3 design system, Riverpod state management.
- **Architecture**: **Server-Driven UI (SDUI)** consuming **IFS Cloud OData v4 REST projections**.
- **Mode**: **Always-Online**. Master data and transactions are never cached locally. Offline queues are strictly forbidden.
- **Branding Rule**: Keep internal code generic (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`). Do NOT introduce `ifs_` prefixes into class names, file names, or variable identifiers.

---

## 2. Hard Invariants & Red Lines

| Rule | Constraint | Enforcement / Failure Mode |
| :--- | :--- | :--- |
| **Max File Length** | **<180 lines** (soft), **<200 lines** (hard) | Split large widgets into subcomponents inside `components/` or separate files. |
| **Command Prefix** | Mandatory `rtk` prefix | Always prepend `rtk` to commands: `rtk dart analyze`, `rtk flutter test`, `rtk git ...` |
| **Online First** | Zero offline transactional mutations | Never implement local SQLite/Hive offline sync queues. API errors must propagate to UI. |
| **Static Analysis** | 0 warnings, 0 errors | Must verify with `rtk dart analyze lib test` before finishing turns. |
| **Test Verification** | 100% test pass rate | Must verify with `rtk flutter test`. |

---

## 3. Graphify Topological Architecture

The codebase has been mapped using Graphify AST analysis (1,174 nodes, 1,724 edges).
Key architectural hubs you will interact with:

```
[LocalStorageService] ──> [ServerConfig] <──> [ApiConfig]
                                                    │
                                                    ▼
[GenericEntityListScreen] <── [ErpCloudService] <── [ApiClient] <── [AuthInterceptor]
          │
          └──> [GenericEntityCard]
          │
          └──> [AppActionDispatcher] ──> [GenericFormSheet]
```

### Key File Index
- `lib/core/network/api_config.dart`: Global singleton managing active server URL, realm, and OAuth tokens.
- `lib/core/network/api_client.dart`: Dio-based HTTP client executing OData v4 operations (`getEntitySet`, `getEntity`, `postEntity`, `patchEntity`, `callAction`).
- `lib/core/network/auth_interceptor.dart`: Auto-injects bearer token; transparently triggers `refreshTokenOAuth()` upon receiving HTTP 401.
- `lib/core/network/odata_query.dart`: Fluent builder for OData query strings (`$filter`, `$select`, `$top`, etc.).
- `lib/core/services/erp_cloud_service.dart`: OData domain projection mapper for work orders and inventory.
- `lib/core/metadata/`: SDUI contracts (`EntitySchemaMetadata`, `ActionMetadata`, `LobbyPageMetadata`, `MenuMetadata`).
- `lib/core/navigation/action_dispatcher.dart`: Central dispatcher executing SDUI navigation and modal actions.
- `lib/core/storage/local_storage_service.dart`: SharedPreferences persistence for server profiles, selected server ID, and theme.
- `lib/features/login/models/server_config.dart`: Profile model defining server URL, realm, and OAuth client credentials.

---

## 4. How-To Recipes for AI Agents

### Recipe A: Adding a New Entity to the App
1. **Define Schema**: Add `EntitySchemaMetadata` in `lib/core/metadata/mock_entity_service.dart` (or load dynamically).
2. **Add Projection Service**: Add fetch and action execution methods in `lib/core/services/erp_cloud_service.dart`.
3. **Connect Route**: Add route key case to `AppActionDispatcher._handleNavigation` in `lib/core/navigation/action_dispatcher.dart`.
4. **Line Count Guard**: Ensure neither file exceeds 180 lines. Split helper mappers into a dedicated file if needed.

### Recipe B: Modifying or Adding a Server Profile Field
1. Update `lib/features/login/models/server_config.dart` (`toJson`, `fromJson`, constructor).
2. Update `lib/features/login/server_form_screen.dart` to add the form field and validation.
3. Update `test/storage_test.dart` to maintain test coverage.

### Recipe C: Adding a New Lobby Tile Type
1. Add enum value to `LobbyElementType` in `lib/core/metadata/lobby_metadata.dart`.
2. Implement widget under `lib/core/widgets/lobby/generic_<type>_element.dart`.
3. Register the widget in `lib/core/widgets/lobby/generic_lobby_element.dart`.

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
