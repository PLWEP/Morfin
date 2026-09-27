# Graph Report - .  (2026-09-27)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 803 nodes · 1077 edges · 70 communities (53 shown, 17 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `815cb86d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- entity_list_screen.dart
- local_storage_service.dart
- user_profile.dart
- menu_screen.dart
- app_colors.dart
- entity_metadata.dart
- splash_screen.dart
- login_screen.dart
- lobby_metadata.dart
- api_config.dart
- activity_log_service.dart
- server_config.dart
- login_contract.dart
- api_client.dart
- lobby_chart_tile.dart
- server_form_screen.dart
- menu_metadata.dart
- StatelessWidget
- ../../theme/app_colors.dart
- action_dispatcher.dart
- settings_screen.dart
- manage_servers_screen.dart
- entity_action_sheet.dart
- erp_cloud_service.dart
- main_shell_screen.dart
- main.dart
- package:flutter/material.dart
- settings_profile_card.dart
- odata_query.dart
- server_form_field.dart
- auth_interceptor.dart
- lobby_element_tile.dart
- industrial_setting_tile.dart
- activity_logs_sheet.dart
- metadata_service.dart
- app_bottom_nav.dart
- @immutable
- entity_schema_registry.dart
- settings_view_model.dart
- cache_manager_service.dart
- action_metadata.dart
- menu_section_card.dart
- activity_log_interceptor.dart
- State
- package:google_fonts/google_fonts.dart
- menu_item_tile.dart
- user_profile_provider.dart
- settings_theme_section.dart
- List
- _SettingsScreenState
- MainActivity
- change_password_screen.dart
- components/notification_card.dart
- components/notifications_filter_pills.dart
- components/notifications_header.dart
- components/notifications_section_header.dart
- components/password_input_field.dart
- components/settings_connectivity_section.dart
- components/settings_operations_section.dart
- components/settings_security_section.dart
- ../../core/metadata/action_metadata.dart
- ../../core/navigation/action_dispatcher.dart
- ../../features/notifications/notifications_screen.dart
- notifications_contract.dart
- ../notifications/notifications_screen.dart
- notifications_provider.dart
- settings_offline_diagnostics_card.dart

## God Nodes (most connected - your core abstractions)
1. `LoginAction` - 10 edges
2. `ServerConfig` - 7 edges
3. `LobbyElementMetadata` - 6 edges
4. `LoginState` - 6 edges
5. `userProfileProvider` - 5 edges
6. `localStorageServiceProvider` - 5 edges
7. `SettingsAction` - 5 edges
8. `ActionMetadata` - 4 edges
9. `EntitySchemaMetadata` - 4 edges
10. `ThemeModeNotifier` - 4 edges

## Surprising Connections (you probably didn't know these)
- `build` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `toggleTheme` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `setThemeMode` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `build` --references--> `userProfileProvider`  [EXTRACTED]
  lib/features/settings/components/settings_profile_card.dart → lib/core/providers/user_profile_provider.dart
- `build` --references--> `userProfileProvider`  [EXTRACTED]
  lib/features/settings/settings_screen.dart → lib/core/providers/user_profile_provider.dart

## Import Cycles
- None detected.

## Communities (70 total, 17 thin omitted)

### Community 0 - "entity_list_screen.dart"
Cohesion: 0.05
Nodes (39): entity_action_sheet.dart, entity_card.dart, entity_detail_screen.dart, EntitySchemaMetadata, FormFieldSetter, EntitySchemaMetadata, build, EntityCard (+31 more)

### Community 1 - "local_storage_service.dart"
Cohesion: 0.06
Nodes (31): dart:convert, HttpOverrides, clearAll, clearLegacyMockData, getActiveServer, getSelectedServerId, getServers, getThemeMode (+23 more)

### Community 2 - "user_profile.dart"
Cohesion: 0.07
Nodes (30): AsyncNotifier, directoryId, displayName, email, fallbackLanguage, fromJson, jobTitle, mobilePhone (+22 more)

### Community 3 - "menu_screen.dart"
Cohesion: 0.07
Nodes (27): components/menu_filter_pills.dart, components/menu_search_bar.dart, ../../core/metadata/lobby_metadata.dart, ../../core/metadata/menu_metadata.dart, ../../core/metadata/metadata_service.dart, ../../core/widgets/lobby/lobby_grid.dart, ../../core/widgets/menu/menu_section_card.dart, build (+19 more)

### Community 4 - "app_colors.dart"
Cohesion: 0.07
Nodes (28): AppColors, AppPalette, dark, isDark, light, of, onPrimaryContainer, onSurface (+20 more)

### Community 5 - "entity_metadata.dart"
Cohesion: 0.07
Nodes (27): actions, ActionScope, codeField, entityName, entitySet, fields, FieldType, formFields (+19 more)

### Community 6 - "splash_screen.dart"
Cohesion: 0.08
Nodes (24): Color, ../../core/widgets/app_logo_badge.dart, CustomPainter, dart:async, AppLogoBadge, _AppLogoPainter, build, paint (+16 more)

### Community 7 - "login_screen.dart"
Cohesion: 0.09
Nodes (24): components/login_form_card.dart, core/network/api_config.dart, build, LoginFormCard, onAction, state, LoginState, build (+16 more)

### Community 8 - "lobby_metadata.dart"
Cohesion: 0.08
Nodes (25): double?, action, benchmark, change, chartPoints, col, colorToken, elements (+17 more)

### Community 9 - "api_config.dart"
Cohesion: 0.09
Nodes (23): bool get, core/storage/local_storage_service.dart, DateTime, ../../features/login/models/server_config.dart, accessToken, activeServer, clearTokens, instance (+15 more)

### Community 10 - "activity_log_service.dart"
Cohesion: 0.08
Nodes (22): ../../../core/services/activity_log_service.dart, ActivityLogEntry, ActivityLogService, clear, details, exportAsText, instance, level (+14 more)

### Community 11 - "server_config.dart"
Cohesion: 0.09
Nodes (21): int get, build, _buildTag, isSelected, onDelete, onEdit, onSelect, server (+13 more)

### Community 12 - "login_contract.dart"
Cohesion: 0.12
Nodes (22): copyWith, initial, isLoading, isObscurePassword, isSuccess, LoginAction, LoginAddServerAction, LoginConsumeNotificationAction (+14 more)

### Community 13 - "api_client.dart"
Cohesion: 0.09
Nodes (21): activity_log_interceptor.dart, auth_interceptor.dart, Dio, authenticateOAuth, callAction, callFunction, _config, _dio (+13 more)

### Community 14 - "lobby_chart_tile.dart"
Cohesion: 0.13
Nodes (18): dart:math, LobbyElementMetadata, build, _buildBarChart, LobbyChartTile, metadata, build, LobbyCounterTile (+10 more)

### Community 15 - "server_form_screen.dart"
Cohesion: 0.12
Nodes (17): components/server_form_field.dart, _baseUrlCtrl, build, _clientIdCtrl, _clientSecretCtrl, createState, _customHostCtrl, dispose (+9 more)

### Community 16 - "menu_metadata.dart"
Cohesion: 0.12
Nodes (16): action_metadata.dart, action, allItems, badgeText, badgeType, category, code, fromJson (+8 more)

### Community 17 - "StatelessWidget"
Cohesion: 0.13
Nodes (14): EntityFormField, ServerCardTile, ServerFormField, MenuFilterPills, build, cacheSizeText, onClearCache, onExportLogs (+6 more)

### Community 18 - "../../theme/app_colors.dart"
Cohesion: 0.14
Nodes (13): build, onAction, ServerEnvironmentSelector, state, build, onCategorySelected, selectedCategory, build (+5 more)

### Community 19 - "action_dispatcher.dart"
Cohesion: 0.13
Nodes (14): _, ../../features/settings/settings_screen.dart, AppActionDispatcher, dispatch, _handleDialog, _handleNavigation, _showToast, _buildBody (+6 more)

### Community 20 - "settings_screen.dart"
Cohesion: 0.14
Nodes (14): components/activity_logs_sheet.dart, components/settings_hardware_storage_section.dart, components/settings_profile_card.dart, components/settings_terminal_lock_card.dart, components/settings_theme_section.dart, SettingsState, createState, dispose (+6 more)

### Community 21 - "manage_servers_screen.dart"
Cohesion: 0.13
Nodes (14): components/server_card_tile.dart, build, _confirmDelete, createState, initState, _navigateToAdd, _navigateToEdit, onAdd (+6 more)

### Community 22 - "entity_action_sheet.dart"
Cohesion: 0.13
Nodes (14): entity_form_field.dart, FormState, actionLabel, build, createState, fields, _formKey, _handleSubmit (+6 more)

### Community 23 - "erp_cloud_service.dart"
Cohesion: 0.15
Nodes (12): ApiClient, _client, createEntityRecord, ErpCloudService, executeAction, executeFunction, fetchEntityRecord, fetchEntitySet (+4 more)

### Community 24 - "main_shell_screen.dart"
Cohesion: 0.18
Nodes (11): components/app_bottom_nav.dart, build, createState, _currentIndex, initialIndex, initState, MainShellScreen, _MainShellScreenState (+3 more)

### Community 25 - "main.dart"
Cohesion: 0.18
Nodes (11): features/login/login_screen.dart, features/shell/main_shell_screen.dart, features/splash/splash_screen.dart, activeServer, build, main, MorfinApp, prefs (+3 more)

### Community 26 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (9): _, _, ColorResolver, resolve, _iconMap, IconResolver, resolve, package:flutter/material.dart (+1 more)

### Community 27 - "settings_profile_card.dart"
Cohesion: 0.20
Nodes (10): ConsumerWidget, ../../../core/models/user_profile.dart, ../../core/providers/user_profile_provider.dart, userProfileProvider, build, _buildContent, SettingsProfileCard, build (+2 more)

### Community 28 - "odata_query.dart"
Cohesion: 0.18
Nodes (10): int?, customParams, expand, filter, ODataQuery, orderby, select, skip (+2 more)

### Community 29 - "server_form_field.dart"
Cohesion: 0.18
Nodes (10): build, controller, hint, icon, isMono, label, obscure, suffix (+2 more)

### Community 30 - "auth_interceptor.dart"
Cohesion: 0.20
Nodes (9): api_client.dart, api_config.dart, Interceptor, ActivityLogInterceptor, ApiConfig, AuthInterceptor, _config, onError (+1 more)

### Community 31 - "lobby_element_tile.dart"
Cohesion: 0.20
Nodes (9): build, LobbyElementTile, metadata, lobby_chart_tile.dart, lobby_counter_tile.dart, lobby_indicator_tile.dart, lobby_link_tile.dart, LobbyElementMetadata (+1 more)

### Community 32 - "industrial_setting_tile.dart"
Cohesion: 0.20
Nodes (9): build, icon, iconColor, IndustrialSettingTile, onTap, subtitle, title, titleSuffix (+1 more)

### Community 33 - "activity_logs_sheet.dart"
Cohesion: 0.22
Nodes (8): activity_log_item_tile.dart, build, _clearLogs, _copyToClipboard, createState, initState, _logs, package:flutter/services.dart

### Community 34 - "metadata_service.dart"
Cohesion: 0.22
Nodes (8): _, AppMetadataService, defaultLobby, defaultMenu, lobby_metadata.dart, menu_metadata.dart, static LobbyPageMetadata get, static MenuMetadata get

### Community 35 - "app_bottom_nav.dart"
Cohesion: 0.22
Nodes (8): IconData, AppBottomNav, build, icon, label, _NavItem, onDestinationSelected, selectedIndex

### Community 36 - "@immutable"
Cohesion: 0.25
Nodes (8): @immutable, ActionMetadata, EntityActionMetadata, EntityFieldMetadata, EntityListCardMetadata, LobbyGridSpan, LobbyPageMetadata, MenuMetadata

### Community 37 - "entity_schema_registry.dart"
Cohesion: 0.25
Nodes (7): _, entity_metadata.dart, EntitySchemaRegistry, findByTarget, inventorySchema, workOrderSchema, static final EntitySchemaMetadata

### Community 38 - "settings_view_model.dart"
Cohesion: 0.25
Nodes (7): ../../core/network/api_client.dart, ../../core/services/cache_manager_service.dart, CacheManagerService, _cacheManager, dispatch, refreshCacheSize, settings_contract.dart

### Community 39 - "cache_manager_service.dart"
Cohesion: 0.25
Nodes (7): dart:io, clearCache, getCacheSizeBytes, getCacheSizeDescription, instance, package:flutter/painting.dart, static final CacheManagerService

### Community 40 - "action_metadata.dart"
Cohesion: 0.25
Nodes (7): ActionType, fromJson, params, target, toJson, type, package:flutter/foundation.dart

### Community 41 - "menu_section_card.dart"
Cohesion: 0.25
Nodes (7): MenuGroupMetadata, build, group, MenuSectionCard, onItemTap, menu_item_tile.dart, ../../metadata/menu_metadata.dart

### Community 42 - "activity_log_interceptor.dart"
Cohesion: 0.25
Nodes (7): onError, onRequest, onResponse, _timers, Map, package:dio/dio.dart, ../services/activity_log_service.dart

### Community 43 - "State"
Cohesion: 0.32
Nodes (8): EntityActionSheet, _EntityActionSheetState, ManageServersScreen, _ManageServersScreenState, ActivityLogsSheet, _ActivityLogsSheetState, State, StatefulWidget

### Community 44 - "package:google_fonts/google_fonts.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, app_text_theme.dart, buildAppTextTheme, AppTheme, package:google_fonts/google_fonts.dart

### Community 45 - "menu_item_tile.dart"
Cohesion: 0.29
Nodes (6): MenuItemMetadata, build, item, MenuItemTile, onTap, _resolveBadgeColors

### Community 46 - "user_profile_provider.dart"
Cohesion: 0.29
Nodes (6): build, clear, _fetchProfile, refresh, ../models/user_profile.dart, ../network/api_client.dart

### Community 47 - "settings_theme_section.dart"
Cohesion: 0.40
Nodes (5): industrial_setting_tile.dart, build, SettingsThemeSection, themeModeProvider, theme/theme_provider.dart

### Community 48 - "List"
Cohesion: 0.33
Nodes (5): build, elements, LobbyGrid, List, lobby_element_tile.dart

### Community 49 - "_SettingsScreenState"
Cohesion: 0.50
Nodes (4): ConsumerState, ConsumerStatefulWidget, SettingsScreen, _SettingsScreenState

## Knowledge Gaps
- **453 isolated node(s):** `ActionType`, `type`, `target`, `params`, `fromJson` (+448 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ServerConfig` connect `server_config.dart` to `@immutable`, `api_config.dart`, `login_contract.dart`, `server_form_screen.dart`, `manage_servers_screen.dart`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **Why does `ApiClient` connect `erp_cloud_service.dart` to `api_client.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Why does `LobbyElementMetadata` connect `lobby_chart_tile.dart` to `lobby_metadata.dart`, `@immutable`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `ActionType`, `type`, `target` to the rest of the system?**
  _453 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `entity_list_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05094130675526024 - nodes in this community are weakly interconnected._
- **Should `local_storage_service.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.062388591800356503 - nodes in this community are weakly interconnected._
- **Should `user_profile.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06818181818181818 - nodes in this community are weakly interconnected._