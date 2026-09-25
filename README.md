# Morfin — Enterprise Mobile ERP Client

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Server--Driven_UI_(SDUI)-emerald.svg)]()
[![Network](https://img.shields.io/badge/Network-Dio_OData_v4-purple.svg)]()
[![Code_Quality](https://img.shields.io/badge/Static_Analysis-0_Issues-brightgreen.svg)]()
[![Tests](https://img.shields.io/badge/Tests-100%25_Passing-success.svg)]()

> **Morfin** is a high-performance, vendor-neutral mobile ERP client built with Flutter. It implements an end-to-end **Server-Driven UI (SDUI)** architecture consuming live **OData v4 REST Projections** (IFS Cloud compatible).

---

## 1. Architectural Invariants (Non-Negotiables)

Any engineer or AI agent contributing to this codebase must adhere strictly to the following principles:

1. **Strictly Always-Online (Zero Offline Transactions)**:
   - ERP operations must always sync live with the backend to ensure master data integrity.
   - Offline-first mutation queues and cached transactional states are intentionally disallowed.
   - Graceful mock fallbacks exist only to support offline UI prototyping and local sandbox testing.
2. **Anti-God-File Policy**:
   - **Soft Limit**: Maximum **180 lines** per file.
   - **Hard Limit**: Maximum **200 lines** per file.
   - Components, viewmodels, contracts, and widgets must be strictly decomposed into focused modules.
3. **Vendor Decoupling**:
   - All internal class names, file paths, and identifiers must remain generic (e.g., `ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`).
   - Enterprise system branding is isolated exclusively to user-facing typography and visual assets.
4. **Mandatory RTK Tooling Prefix**:
   - All terminal, build, test, and git commands must be executed with the `rtk` wrapper prefix (e.g., `rtk dart analyze lib`, `rtk flutter test`, `rtk git status`).

---

## 2. Knowledge Graph & Architecture Hubs (Graphify)

The codebase has been indexed via **Graphify AST extraction** to provide full topological traceability:
- **Total Nodes**: 1,174
- **Total Edges**: 1,724
- **Communities**: 69
- **Visual Artifacts**:
  - Interactive D3 Component Hierarchy: `graphify-out/GRAPH_TREE.html`
  - Interactive Mermaid Call-Flow & Sequence: `graphify-out/morfin-callflow.html`

### Top Architectural Hubs (God Nodes)
These 10 nodes form the structural backbone of the application:

| Rank | Architectural Node | Type | Connected Edges | Role |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `localStorageServiceProvider` | Provider | 12 | Persists user preferences and server profiles |
| 2 | `LoginAction` | Sealed Class | 10 | Action contracts driving authentication and server selection |
| 3 | `SettingsAction` | Sealed Class | 9 | Global theme and application configuration events |
| 4 | `LobbyElementMetadata` | Contract | 7 | Dynamic layout and data definition for Lobby dashboard tiles |
| 5 | `ServerConfig` | Data Model | 7 | OData endpoint credentials, URLs, and realm definitions |
| 6 | `LoginState` | State Model | 6 | Reactive authentication and active server selection state |
| 7 | `workOrderProvider` | Provider | 6 | State management for maintenance work orders |
| 8 | `EntitySchemaMetadata` | Contract | 5 | SDUI schema definition for dynamic entity lists and details |
| 9 | `inventoryProvider` | Provider | 5 | State management for warehouse parts and stock levels |
| 10 | `NotificationsAction` | Sealed Class | 5 | System alert and push event contracts |

---

## 3. Directory Layout & Layer Responsibilities

```
lib/
├── core/
│   ├── metadata/            # SDUI Data Models (Schemas, Cards, Actions, Lobby, Menu)
│   │   ├── action_metadata.dart
│   │   ├── entity_metadata.dart
│   │   ├── lobby_metadata.dart
│   │   └── menu_metadata.dart
│   ├── navigation/          # Dynamic Navigation & Route Handlers
│   │   └── action_dispatcher.dart
│   ├── network/             # Dio HTTP Client & OData v4 Integration
│   │   ├── api_client.dart          # HTTP verbs, OData projection calls, OAuth
│   │   ├── api_config.dart          # Active server target & token storage
│   │   ├── auth_interceptor.dart    # Token injection & transparent 401 refresh
│   │   └── odata_query.dart         # Query string builder ($filter, $select, $top)
│   ├── services/            # Domain Projection Gateways
│   │   └── erp_cloud_service.dart   # OData mapper for Work Orders & Inventory
│   ├── storage/             # Device Local Storage
│   │   └── local_storage_service.dart # SharedPreferences wrapper for servers & theme
│   ├── utils/               # Resolvers & Helpers
│   │   ├── color_resolver.dart
│   │   └── icon_resolver.dart
│   └── widgets/             # Generic SDUI UI Components
│       ├── entity/          # GenericEntityCard, GenericEntityListScreen, etc.
│       ├── forms/           # GenericFormSheet, GenericFormField
│       ├── lobby/           # GenericLobbyGrid, GenericCounter, GenericChart
│       └── menu/            # GenericMenuSection, GenericMenuTile
├── features/
│   ├── login/               # Authentication & Server Profile Management
│   │   ├── components/      # ServerCardTile, LoginFormCard, ServerFormField
│   │   ├── models/          # ServerConfig
│   │   ├── login_screen.dart
│   │   ├── manage_servers_screen.dart
│   │   └── server_form_screen.dart
│   ├── lobby/               # Dynamic Dashboard Screens
│   ├── menu/                # Dynamic Navigator Menus
│   ├── shell/               # Main Navigation Bar & App Shell
│   ├── notifications/       # System Alerts & Messages
│   └── settings/            # User Preferences & Theme Toggle
└── theme/                   # Material 3 Dynamic Palette & Tokens
```

---

## 4. Core Technical Workflows

### A. Server-Driven UI (SDUI) Rendering Pipeline
```
[Backend / Mock Schema] ──> EntitySchemaMetadata
                                 │
                                 ├──> GenericEntityListScreen (Dynamic Appbar, Search, FAB)
                                 │         │
                                 │         └──> GenericEntityCard (Dynamic fields, priority badges)
                                 │
                                 └──> AppActionDispatcher ──> GenericFormSheet (Dynamic forms)
```

1. **Schema Definition**: Entities declare their fields, keys, filters, and actionable mutations via `EntitySchemaMetadata`.
2. **Rendering**: `GenericEntityListScreen` reads `EntityListCardMetadata` to project raw data into uniform UI components without hardcoded entity screens.
3. **Actions**: Dynamic actions (`create`, `edit`, `change_status`) render dynamic bottom sheets via `GenericFormSheet`.

### B. OData v4 Network Pipeline
```
ErpCloudService ──> ApiClient ──> AuthInterceptor ──> IFS Cloud OData v4 Endpoint
                         ▲              │ (401 Response)
                         │              ▼
                         └────── ApiClient.refreshTokenOAuth()
```

1. **Target Routing**: `ApiConfig.instance.activeServer` provides the base URL and realm.
2. **Query Building**: `ODataQuery` constructs queries supporting `$filter`, `$select`, `$expand`, `$top`, and `$skip`.
3. **Session Management**: `AuthInterceptor` injects `Authorization: Bearer <token>`. Upon receiving an HTTP 401, it attempts token refresh via OAuth `grant_type: refresh_token` and transparently retries the failed request.

### C. Server Configuration & Persistence
- Configured servers and the currently active server ID are saved locally via `LocalStorageService`.
- Switching servers in `ManageServersScreen` immediately calls `ApiConfig.instance.setServer(...)` and `LocalStorageService.saveSelectedServerId(...)`, directing all subsequent OData API calls to the chosen instance without requiring an app reload.

---

## 5. Development & Contribution Guide

### Verification Checklist
Before submitting any pull request or committing code, run:
```bash
# 1. Static code analysis (must report 0 issues)
rtk dart analyze lib test

# 2. Automated test suite (all tests must pass)
rtk flutter test

# 3. Line count check (all files must be <180 lines)
rtk git ls-files lib/*.dart | ForEach-Object { "$_ : $((Get-Content $_).Count) lines" }
```

### Running Locally
To avoid Android Emulator Out-Of-Memory (OOM) constraints on Windows machines, run the Windows desktop target:
```bash
rtk flutter run -d windows
```

### Adding a New Entity Projection
1. Define the schema in `lib/core/metadata/mock_entity_service.dart` or fetch dynamically from backend metadata.
2. Add projection mappings to `lib/core/services/erp_cloud_service.dart` with endpoint names.
3. Register route keys in `lib/core/navigation/action_dispatcher.dart`.
4. Ensure all new files remain under the 180-line ceiling.
