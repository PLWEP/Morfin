# Morfin — Enterprise Mobile ERP Client

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Server--Driven_UI_(SDUI)-emerald.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Android_Native-green.svg)]()
[![Network](https://img.shields.io/badge/Network-Dio_OData_v4-purple.svg)]()
[![Code_Quality](https://img.shields.io/badge/Static_Analysis-0_Issues-brightgreen.svg)]()
[![Tests](https://img.shields.io/badge/Tests-100%25_Passing-success.svg)]()

> **Morfin** is a high-performance, vendor-neutral native Android mobile ERP client built with Flutter. It implements an end-to-end **Server-Driven UI (SDUI)** architecture consuming live **OData v4 REST Projections** (IFS Cloud compatible) with strict MVVM and Material Design 3.

---

## 1. Architectural Invariants (Non-Negotiables)

Any engineer or AI agent contributing to this codebase must adhere strictly to the following principles:

1. **Target Platform**:
   - **Android only**. No cross-platform shims, iOS pods, or redundant platform checks.
2. **Strictly Always-Online (Zero Offline Transactions)**:
   - ERP operations must always sync live with backend OData projections to ensure master data integrity.
   - Offline-first mutation queues and cached transactional states are intentionally disallowed.
3. **Anti-God-File Policy**:
   - **Soft Limit**: Maximum **180 lines** per file.
   - **Hard Limit**: Maximum **200 lines** per file.
   - Components, viewmodels, contracts, and widgets must be strictly decomposed into focused modules. Zero God Objects.
4. **Design System & UI Standards**:
   - Material Design 3 (M3) with dynamic Light & Dark themes.
   - Strictly adhere to `antislop-ui` standards: clean, deterministic layouts; eliminate bloated abstractions, generic placeholder wrappers, and decorative UI slop.
5. **Testing Directive**:
   - Do NOT generate test suites, unit tests, or instrumentation tests unless explicitly instructed.
6. **Vendor Decoupling**:
   - All internal class names, file paths, and identifiers must remain vendor-neutral (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`, `EntitySchemaRegistry`).
   - Enterprise system branding is isolated exclusively to user-facing typography and visual assets.
7. **Mandatory RTK Tooling Prefix**:
   - All terminal, build, test, and git commands must be executed with the `rtk` wrapper prefix (e.g., `rtk dart analyze lib test`, `rtk flutter test`, `rtk git status`).

---

## 2. Knowledge Graph & Architecture Hubs (Graphify)

The codebase is indexed via **Graphify AST extraction** to provide full topological traceability:
- **Total Nodes**: 811
- **Total Edges**: 1,155
- **Communities**: 56
- **Visual Artifacts**:
  - Interactive D3 Component Hierarchy: `graphify-out/GRAPH_TREE.html`
  - Interactive Mermaid Call-Flow & Sequence: `graphify-out/morfin-callflow.html`

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

---

## 3. Directory Layout & Layer Responsibilities

```
lib/
├── core/
│   ├── metadata/            # SDUI Data Models (Schemas, Cards, Actions, Lobby, Menu)
│   │   ├── action_metadata.dart
│   │   ├── entity_metadata.dart
│   │   ├── entity_schema_registry.dart # Registered entity schemas & route lookup
│   │   ├── lobby_metadata.dart
│   │   ├── menu_metadata.dart
│   │   └── metadata_service.dart
│   ├── navigation/          # Dynamic Navigation & Route Handlers
│   │   └── action_dispatcher.dart      # Schema-driven action and route dispatcher
│   ├── network/             # Dio HTTP Client & OData v4 Integration
│   │   ├── api_client.dart             # HTTP verbs, OData projection calls, OAuth
│   │   ├── api_config.dart             # Active server target & token storage
│   │   ├── auth_interceptor.dart       # Token injection & transparent 401 refresh
│   │   └── odata_query.dart            # Query string builder ($filter, $select, $top)
│   ├── services/            # Generic Domain Projection Gateways
│   │   └── erp_cloud_service.dart      # OData fetchEntitySet, create, update, action
│   ├── storage/             # Device Local Storage
│   │   └── local_storage_service.dart  # SharedPreferences for servers & theme
│   ├── utils/               # Resolvers & Helpers
│   │   ├── color_resolver.dart
│   │   └── icon_resolver.dart
│   └── widgets/             # Reusable SDUI Components
│       ├── entity/          # EntityCard, EntityListScreen, EntityDetailScreen, EntityActionSheet
│       ├── lobby/           # LobbyGrid, LobbyElementTile, LobbyCounterTile, LobbyChartTile
│       └── menu/            # MenuSectionCard, MenuItemTile
├── features/
│   ├── login/               # Authentication & Server Profile Management
│   │   ├── components/      # ServerCardTile, LoginFormCard, ServerFormField
│   │   ├── models/          # ServerConfig
│   │   ├── login_screen.dart
│   │   ├── manage_servers_screen.dart
│   │   └── server_form_screen.dart
│   ├── lobby/               # Dynamic Dashboard Screens (LobbyScreen)
│   ├── menu/                # Dynamic Navigator Menus (MenuScreen)
│   ├── shell/               # Main Navigation Bar & App Shell (MainShellScreen)
│   ├── notifications/       # System Alerts & Activity Messages
│   └── settings/            # User Preferences & Theme Toggle
└── theme/                   # Material 3 Dynamic Palette & Tokens
```

---

## 4. Core Technical Workflows

### A. Server-Driven UI (SDUI) Rendering Pipeline
```
[Backend Metadata / Registry] ──> EntitySchemaMetadata
                                      │
                                      ├──> EntityListScreen (Dynamic Appbar, Search, FAB)
                                      │         │
                                      │         └──> EntityCard (Dynamic fields, priority badges)
                                      │
                                      └──> AppActionDispatcher ──> EntityActionSheet (Dynamic forms)
```

1. **Schema Definition**: Entities declare their projection name, entity set, fields, keys, filters, and actionable mutations via `EntitySchemaMetadata`.
2. **Rendering**: `EntityListScreen` reads `EntityListCardMetadata` to project raw OData records into uniform UI components without hardcoded entity screens.
3. **Actions**: Dynamic actions (`create`, `change_status`, `execute_action`) render dynamic bottom sheets via `EntityActionSheet`.

### B. OData v4 Network Pipeline
```
ErpCloudService ──> ApiClient ──> AuthInterceptor ──> OData v4 Endpoint
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
rtk python "C:\Users\MP2NE93D\.gemini\antigravity-ide\brain\253681d4-7a46-4b8e-8953-a688a8bbbae0\scratch\check_lines.py"
```

### Adding a New Entity Projection
1. Register the schema in `lib/core/metadata/entity_schema_registry.dart` with `projection` and `entitySet`.
2. Register the route alias in `EntitySchemaRegistry.findByTarget(...)`.
3. The entity is immediately browsable, searchable, and actionable across the app without writing a single new screen or widget!
