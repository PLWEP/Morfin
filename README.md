# Morfin — Enterprise Mobile ERP Client

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Server--Driven_UI_(SDUI)-emerald.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Android_Native-green.svg)]()
[![Network](https://img.shields.io/badge/Network-Dio_REST_Projections-purple.svg)]()
[![Static_Analysis](https://img.shields.io/badge/Static_Analysis-0_Issues-brightgreen.svg)]()
[![Tests](https://img.shields.io/badge/Tests-100%25_Passing-success.svg)]()

> **Morfin** is a high-performance, vendor-neutral native Android ERP client built with Flutter. It implements an end-to-end **Server-Driven UI (SDUI)** architecture consuming live **REST Projections** (IFS Cloud compatible) with strict MVVM, Material Design 3, and Unidirectional Data Flow (UDF).

---

## 1. Architectural Invariants (Non-Negotiables)

Any engineer or AI agent contributing to this codebase must adhere strictly to the following principles:

1. **Target Platform**:
   - **Android only**. No cross-platform shims, iOS pods, or redundant platform checks.
2. **Strictly Always-Online (Zero Offline Transactions)**:
   - ERP operations always sync live with backend REST projections to guarantee master data integrity.
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
6. **Vendor Decoupling & Professional Naming**:
   - All internal class names, contracts, and identifiers must remain vendor-neutral (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `BackendService`, `RecordSchemaRegistry`, `RecordFieldMetadata`).
   - Legacy prefixes (`ifs_`) and informal colloquialisms (`mobile`, `odata`, `entity` when referring to generic records) are avoided in internal domain models.
7. **Mandatory RTK Tooling Prefix**:
   - All terminal, build, test, and git commands must be executed with the `rtk` wrapper prefix (e.g., `rtk dart analyze lib test`, `rtk flutter test`, `rtk git status`).

---

## 2. Knowledge Graph & Architecture Hubs (Graphify)

The codebase is indexed via **Graphify AST extraction** to provide full topological traceability:
- **Total Nodes**: 1,068
- **Total Edges**: 1,443
- **Visual Artifacts**:
  - Interactive Component Hierarchy: `graphify-out/GRAPH_TREE.html`
  - Interactive Call-Flow & Sequence: `graphify-out/morfin-callflow.html`

### Top Architectural Hubs
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

---

## 3. Directory Layout & Layer Responsibilities

```
lib/
├── core/
│   ├── metadata/            # SDUI Data Models (Schemas, Cards, Actions, Lobby, Menu)
│   │   ├── action_metadata.dart
│   │   ├── record_metadata.dart
│   │   ├── record_schema_registry.dart # Dynamic record schemas & route lookup
│   │   ├── lobby_metadata.dart
│   │   └── menu_metadata.dart
│   ├── models/              # Core Domain Data Models
│   │   ├── navigation_node.dart        # Dynamic navigator node & param config
│   │   └── user_profile.dart           # User profile model
│   ├── navigation/          # Dynamic Navigation & Route Handlers
│   │   └── action_dispatcher.dart      # Schema-driven action and route dispatcher
│   ├── network/             # Dio HTTP Client & REST Projection Integration
│   │   ├── activity_log_interceptor.dart # Live request/response telemetry recorder
│   │   ├── api_client.dart             # HTTP verbs, projection calls, OAuth
│   │   ├── api_config.dart             # Active server target & token storage
│   │   ├── auth_interceptor.dart       # Token injection & transparent 401 refresh
│   │   └── data_query.dart             # Query builder ($filter, $select, $top)
│   ├── providers/           # Shared Riverpod Global State Providers
│   │   ├── lobby_provider.dart         # Dynamic lobby aggregation provider
│   │   └── user_profile_provider.dart  # Live FrameworkServices user info provider
│   ├── services/            # Domain Projection & Utility Gateways
│   │   ├── activity_log_service.dart   # In-memory diagnostics logger & exporter
│   │   ├── backend_service.dart        # Core projection gateway & batch executor
│   │   ├── cache_manager_service.dart  # Cache directory size calculator & purger
│   │   ├── industrial_feedback_service.dart # Haptic & sound cues for warehouse ops
│   │   ├── navigator_service.dart      # Dynamic navigation hierarchy service
│   │   └── schema_catalog_service.dart # Live projection schema discovery & XML metadata
│   ├── storage/             # Device Local Storage
│   │   └── local_storage_service.dart  # SharedPreferences for servers & theme
│   ├── utils/               # Resolvers, Sanitizers & Parsers
│   │   ├── action_field_consolidator.dart
│   │   ├── action_metadata_loader.dart
│   │   ├── color_resolver.dart
│   │   ├── column_config_parser.dart
│   │   ├── icon_resolver.dart
│   │   ├── param_config_parser.dart
│   │   ├── payload_utils.dart
│   │   └── record_lookup_loader.dart
│   └── widgets/             # Reusable SDUI Components
│       ├── record/          # RecordCard, RecordListScreen, RecordDetailScreen, RecordActionSheet, RecordFormField, BarcodeScannerSheet
│       ├── lobby/           # LobbyGrid, LobbyElementTile, LobbyCounterTile, LobbyChartTile, LobbyDetailSheet, LobbyDetailSections
│       └── menu/            # MenuSectionCard, MenuItemTile, ModuleInfoSheet
├── features/
│   ├── login/               # Authentication & Server Profile Management
│   ├── lobby/               # Dynamic Dashboard Screens (LobbyScreen)
│   ├── menu/                # Dynamic Navigator Menus (MenuScreen)
│   ├── shell/               # 3-Tab Main Navigation Bar & Shell (MainShellScreen)
│   ├── splash/              # Initialization & Session Recovery (SplashScreen)
│   └── settings/            # User Preferences, Theme, Diagnostics, Cache Management
└── theme/                   # Material 3 Dynamic Palette & Tokens
```

---

## 4. Core Technical Workflows

### A. Server-Driven UI (SDUI) Rendering Pipeline
```
[Backend Metadata / Registry] ──> RecordSchemaMetadata
                                      │
                                      ├──> RecordListScreen (Dynamic Appbar, Search, FAB)
                                      │         │
                                      │         └──> RecordCard (Aligned table grid, status badges)
                                      │
                                      └──> ActionDispatcher ──> RecordActionSheet (Dynamic forms & wizards)
```

1. **Schema Definition**: Projections declare their projection name, entity set, fields, keys, filters, and actionable mutations via `RecordSchemaMetadata`.
2. **Rendering**: `RecordListScreen` reads schema configuration to project raw records into uniform UI components without hardcoded record screens.
3. **Actions**: Dynamic actions (`create`, `form_dialog`, `action`) render dynamic bottom sheets via `RecordActionSheet` and step-by-step wizard modes for complex industrial input.

### B. Network Pipeline
```
BackendService ──> ApiClient ──> AuthInterceptor ──> REST Projection Endpoint
                         ▲              │ (401 Response)
                         │              ▼
                         └────── ApiClient.refreshTokenOAuth()
```

1. **Target Routing**: `ApiConfig.instance.activeServer` provides the base URL and realm.
2. **Query Building**: `DataQuery` constructs queries supporting `$filter`, `$select`, `$expand`, `$top`, and `$skip` complying with RFC OData v4 query syntax.
3. **Session Management**: `AuthInterceptor` injects `Authorization: Bearer <token>`. Upon receiving an HTTP 401, it attempts token refresh via OAuth `grant_type: refresh_token` and transparently retries the failed request.

### C. Server Configuration & Persistence
- Configured servers and the currently active server ID are saved locally via `LocalStorageService`.
- Switching servers in `ManageServersScreen` immediately calls `ApiConfig.instance.setServer(...)` and `LocalStorageService.saveSelectedServerId(...)`, directing all subsequent API calls to the chosen instance without requiring an app reload.

---

## 5. Development & Contribution Guide

### Verification Checklist
Before submitting any pull request or committing code, run:
```bash
# 1. Static code analysis (must report 0 issues)
rtk dart analyze lib test

# 2. Automated test suite (all tests must pass)
rtk flutter test
```

### Adding a New Record Projection
1. Register the schema in `lib/core/metadata/record_schema_registry.dart` with `projection` and `entitySet`.
2. Register the route alias in `RecordSchemaRegistry.findByTarget(...)`.
3. The record collection is immediately browsable, searchable, and actionable across the app without writing a single new screen or widget.
