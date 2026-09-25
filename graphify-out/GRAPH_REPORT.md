# Graph Report - .  (2026-09-25)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 811 nodes · 1155 edges · 56 communities (55 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `839e27be`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- entity_metadata.dart
- settings_screen.dart
- api_client.dart
- industrial_setting_tile.dart
- lobby_chart_tile.dart
- menu_screen.dart
- login_screen.dart
- server_form_screen.dart
- lobby_metadata.dart
- notifications_contract.dart
- login_contract.dart
- menu_metadata.dart
- notifications_screen.dart
- manage_servers_screen.dart
- local_storage_service.dart
- settings_contract.dart
- change_password_screen.dart
- entity_list_screen.dart
- main_shell_screen.dart
- main.dart
- entity_detail_screen.dart
- entity_action_sheet.dart
- ../../theme/app_colors.dart
- api_config.dart
- server_config.dart
- StatelessWidget
- package:google_fonts/google_fonts.dart
- splash_screen.dart
- theme_provider.dart
- entity_form_field.dart
- server_card_tile.dart
- metadata_service.dart
- action_metadata.dart
- entity_card.dart
- VoidCallback
- entity_schema_registry.dart
- login_view_model.dart
- menu_section_card.dart
- notifications_filter_pills.dart
- notifications_provider.dart
- menu_item_tile.dart
- notification_card.dart
- package:flutter/material.dart
- settings_profile_card.dart
- @immutable
- icon_resolver.dart
- notifications_section_header.dart
- settings_connectivity_section.dart
- settings_hardware_storage_section.dart
- storage_test.dart
- notifications_header.dart
- MainActivity

## God Nodes (most connected - your core abstractions)
1. `LoginAction` - 10 edges
2. `SettingsAction` - 9 edges
3. `LobbyElementMetadata` - 7 edges
4. `ServerConfig` - 7 edges
5. `LoginState` - 6 edges
6. `EntitySchemaMetadata` - 5 edges
7. `localStorageServiceProvider` - 5 edges
8. `NotificationsAction` - 5 edges
9. `themeModeProvider` - 5 edges
10. `ActionMetadata` - 4 edges

## Surprising Connections (you probably didn't know these)
- `build` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `setThemeMode` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `toggleTheme` --references--> `localStorageServiceProvider`  [EXTRACTED]
  lib/theme/theme_provider.dart → lib/core/storage/local_storage_service.dart
- `SettingsThemeSection` --references--> `themeModeProvider`  [EXTRACTED]
  lib/features/settings/components/settings_theme_section.dart → lib/theme/theme_provider.dart
- `build` --references--> `themeModeProvider`  [EXTRACTED]
  lib/features/settings/components/settings_theme_section.dart → lib/theme/theme_provider.dart

## Import Cycles
- None detected.

## Communities (56 total, 1 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.04
Nodes (42): Color, CustomPainter, AppLogoBadge, _AppLogoPainter, build, paint, shouldRepaint, size (+34 more)

### Community 1 - "entity_metadata.dart"
Cohesion: 0.05
Nodes (42): actions, ActionScope, codeField, entityName, entitySet, fields, FieldType, formFields (+34 more)

### Community 2 - "settings_screen.dart"
Cohesion: 0.05
Nodes (37): _, change_password_screen.dart, components/settings_connectivity_section.dart, components/settings_hardware_storage_section.dart, components/settings_operations_section.dart, components/settings_profile_card.dart, components/settings_security_section.dart, components/settings_terminal_lock_card.dart (+29 more)

### Community 3 - "api_client.dart"
Cohesion: 0.06
Nodes (35): api_client.dart, api_config.dart, auth_interceptor.dart, Dio, Interceptor, ApiClient, authenticateOAuth, callAction (+27 more)

### Community 4 - "industrial_setting_tile.dart"
Cohesion: 0.06
Nodes (29): IconData, build, controller, hint, icon, isMono, label, obscure (+21 more)

### Community 5 - "lobby_chart_tile.dart"
Cohesion: 0.09
Nodes (26): dart:math, LobbyElementMetadata, build, _buildBarChart, LobbyChartTile, metadata, build, LobbyCounterTile (+18 more)

### Community 6 - "menu_screen.dart"
Cohesion: 0.07
Nodes (27): components/menu_filter_pills.dart, components/menu_search_bar.dart, ../../core/metadata/lobby_metadata.dart, ../../core/metadata/menu_metadata.dart, ../../core/metadata/metadata_service.dart, ../../core/widgets/lobby/lobby_grid.dart, ../../core/widgets/menu/menu_section_card.dart, build (+19 more)

### Community 7 - "login_screen.dart"
Cohesion: 0.09
Nodes (23): components/login_form_card.dart, build, LoginFormCard, onAction, state, build, onAction, ServerEnvironmentSelector (+15 more)

### Community 8 - "server_form_screen.dart"
Cohesion: 0.08
Nodes (24): components/server_form_field.dart, _baseUrlCtrl, build, _clientIdCtrl, _clientSecretCtrl, createState, dispose, _formKey (+16 more)

### Community 9 - "lobby_metadata.dart"
Cohesion: 0.08
Nodes (25): double?, action, benchmark, change, chartPoints, col, colorToken, elements (+17 more)

### Community 10 - "notifications_contract.dart"
Cohesion: 0.10
Nodes (23): activeFilter, copyWith, filter, group, icon, id, isRead, items (+15 more)

### Community 11 - "login_contract.dart"
Cohesion: 0.12
Nodes (22): copyWith, initial, isLoading, isObscurePassword, isSuccess, LoginAction, LoginAddServerAction, LoginConsumeNotificationAction (+14 more)

### Community 12 - "menu_metadata.dart"
Cohesion: 0.12
Nodes (16): action_metadata.dart, action, allItems, badgeText, badgeType, category, code, fromJson (+8 more)

### Community 13 - "notifications_screen.dart"
Cohesion: 0.13
Nodes (16): components/notification_card.dart, components/notifications_filter_pills.dart, components/notifications_header.dart, components/notifications_section_header.dart, ConsumerWidget, ../../core/metadata/action_metadata.dart, ../../core/navigation/action_dispatcher.dart, notificationsProvider (+8 more)

### Community 14 - "manage_servers_screen.dart"
Cohesion: 0.12
Nodes (16): components/server_card_tile.dart, build, _confirmDelete, createState, initState, ManageServersScreen, _ManageServersScreenState, _navigateToAdd (+8 more)

### Community 15 - "local_storage_service.dart"
Cohesion: 0.12
Nodes (16): dart:convert, clearAll, getActiveServer, getSelectedServerId, getServers, getThemeMode, _keySelectedServerId, _keyServers (+8 more)

### Community 16 - "settings_contract.dart"
Cohesion: 0.18
Nodes (16): cacheSizeText, copyWith, isEscalationAlertsEnabled, isOfflineModeEnabled, newPassword, SettingsAction, SettingsChangePassword, SettingsClearCache (+8 more)

### Community 17 - "change_password_screen.dart"
Cohesion: 0.14
Nodes (14): components/password_input_field.dart, FormState, build, ChangePasswordScreen, _ChangePasswordScreenState, _confirmPasswordCtrl, createState, dispose (+6 more)

### Community 18 - "entity_list_screen.dart"
Cohesion: 0.14
Nodes (14): entity_card.dart, entity_detail_screen.dart, build, createState, EntityListScreen, _EntityListScreenState, _error, initState (+6 more)

### Community 19 - "main_shell_screen.dart"
Cohesion: 0.15
Nodes (13): components/app_bottom_nav.dart, build, createState, _currentIndex, initialIndex, initState, MainShellScreen, _MainShellScreenState (+5 more)

### Community 20 - "main.dart"
Cohesion: 0.15
Nodes (13): core/network/api_config.dart, features/login/login_screen.dart, features/shell/main_shell_screen.dart, features/splash/splash_screen.dart, build, activeServer, build, main (+5 more)

### Community 21 - "entity_detail_screen.dart"
Cohesion: 0.16
Nodes (13): entity_action_sheet.dart, EntityActionSheet, _EntityActionSheetState, build, createState, EntityDetailScreen, _EntityDetailScreenState, initState (+5 more)

### Community 22 - "entity_action_sheet.dart"
Cohesion: 0.14
Nodes (13): entity_form_field.dart, actionLabel, build, createState, fields, _formKey, _handleSubmit, initialValues (+5 more)

### Community 23 - "../../theme/app_colors.dart"
Cohesion: 0.17
Nodes (10): _, industrial_setting_tile.dart, ColorResolver, resolve, build, isEscalationAlerts, onEscalationAlertsChanged, SettingsOperationsSection (+2 more)

### Community 24 - "api_config.dart"
Cohesion: 0.15
Nodes (12): DateTime?, ../../features/login/models/server_config.dart, accessToken, activeServer, clearTokens, instance, isAuthenticated, refreshToken (+4 more)

### Community 25 - "server_config.dart"
Cohesion: 0.15
Nodes (12): int get, baseUrl, clientId, clientSecret, copyWith, fromJson, hashCode, id (+4 more)

### Community 26 - "StatelessWidget"
Cohesion: 0.17
Nodes (11): build, MenuFilterPills, onCategorySelected, selectedCategory, build, MenuSearchBar, onQueryChanged, NotificationsFilterPills (+3 more)

### Community 27 - "package:google_fonts/google_fonts.dart"
Cohesion: 0.18
Nodes (9): app_colors.dart, app_text_theme.dart, build, _buildStatBox, onSyncNow, SettingsOfflineDiagnosticsCard, buildAppTextTheme, AppTheme (+1 more)

### Community 28 - "splash_screen.dart"
Cohesion: 0.20
Nodes (10): ../../core/widgets/app_logo_badge.dart, dart:async, build, createState, dispose, initState, SplashScreen, _SplashScreenState (+2 more)

### Community 29 - "theme_provider.dart"
Cohesion: 0.27
Nodes (9): bool get, core/storage/local_storage_service.dart, localStorageServiceProvider, build, isDarkMode, setThemeMode, ThemeModeNotifier, toggleTheme (+1 more)

### Community 30 - "entity_form_field.dart"
Cohesion: 0.20
Nodes (9): FormFieldSetter, EntityFieldMetadata, build, _decoration, EntityFormField, field, initialValue, onChanged (+1 more)

### Community 31 - "server_card_tile.dart"
Cohesion: 0.20
Nodes (9): build, _buildTag, isSelected, onDelete, onEdit, onSelect, server, ServerCardTile (+1 more)

### Community 32 - "metadata_service.dart"
Cohesion: 0.22
Nodes (8): _, AppMetadataService, defaultLobby, defaultMenu, lobby_metadata.dart, menu_metadata.dart, static LobbyPageMetadata get, static MenuMetadata get

### Community 33 - "action_metadata.dart"
Cohesion: 0.22
Nodes (8): ActionMetadata, ActionType, fromJson, params, target, toJson, type, Map

### Community 34 - "entity_card.dart"
Cohesion: 0.22
Nodes (8): EntitySchemaMetadata, build, EntityCard, onTap, record, _resolveStatusColor, schema, ../../metadata/entity_metadata.dart

### Community 35 - "VoidCallback"
Cohesion: 0.22
Nodes (7): build, onChangePasswordTap, SettingsSecuritySection, build, onLockTerminal, SettingsTerminalLockCard, VoidCallback

### Community 36 - "entity_schema_registry.dart"
Cohesion: 0.25
Nodes (7): _, entity_metadata.dart, EntitySchemaRegistry, findByTarget, inventorySchema, workOrderSchema, static final EntitySchemaMetadata

### Community 37 - "login_view_model.dart"
Cohesion: 0.25
Nodes (7): ../../core/network/api_client.dart, dispatch, _executeLogin, _loadStoredServers, _persist, models/server_config.dart, package:flutter/foundation.dart

### Community 38 - "menu_section_card.dart"
Cohesion: 0.25
Nodes (7): MenuGroupMetadata, build, group, MenuSectionCard, onItemTap, menu_item_tile.dart, ../../metadata/menu_metadata.dart

### Community 39 - "notifications_filter_pills.dart"
Cohesion: 0.25
Nodes (7): activeFilter, build, onFilterSelected, readCount, totalCount, unreadCount, NotificationFilter

### Community 40 - "notifications_provider.dart"
Cohesion: 0.25
Nodes (7): NotificationsState, build, dispatch, NotificationsNotifier, notifications_contract.dart, Notifier, package:flutter_riverpod/flutter_riverpod.dart

### Community 41 - "menu_item_tile.dart"
Cohesion: 0.29
Nodes (6): MenuItemMetadata, build, item, MenuItemTile, onTap, _resolveBadgeColors

### Community 42 - "notification_card.dart"
Cohesion: 0.29
Nodes (6): build, item, NotificationCard, onDismiss, onTap, NotificationItem

### Community 43 - "package:flutter/material.dart"
Cohesion: 0.29
Nodes (5): build, imageUrl, SettingsProfileAvatar, dispatch, package:flutter/material.dart

### Community 44 - "settings_profile_card.dart"
Cohesion: 0.29
Nodes (6): _avatarUrl, build, _buildDetails, SettingsProfileCard, settings_profile_avatar.dart, static const

### Community 45 - "@immutable"
Cohesion: 0.33
Nodes (6): @immutable, EntityActionMetadata, EntityListCardMetadata, LobbyGridSpan, LobbyPageMetadata, MenuMetadata

### Community 46 - "icon_resolver.dart"
Cohesion: 0.33
Nodes (5): _, _iconMap, IconResolver, resolve, static const Map

### Community 47 - "notifications_section_header.dart"
Cohesion: 0.33
Nodes (5): int?, build, count, NotificationsSectionHeader, title

### Community 48 - "settings_connectivity_section.dart"
Cohesion: 0.33
Nodes (5): build, isOfflineMode, onOfflineModeChanged, onSyncNow, settings_offline_diagnostics_card.dart

### Community 49 - "settings_hardware_storage_section.dart"
Cohesion: 0.33
Nodes (5): build, cacheSizeText, onClearCache, onExportLogs, SettingsHardwareStorageSection

### Community 50 - "storage_test.dart"
Cohesion: 0.33
Nodes (5): package:flutter_test/flutter_test.dart, package:morfin/core/storage/local_storage_service.dart, package:morfin/features/login/models/server_config.dart, package:shared_preferences/shared_preferences.dart, main

### Community 51 - "notifications_header.dart"
Cohesion: 0.40
Nodes (4): build, NotificationsHeader, onMarkAllRead, unreadCount

## Knowledge Gaps
- **468 isolated node(s):** `ActionType`, `type`, `target`, `params`, `fromJson` (+463 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ApiConfig` connect `api_client.dart` to `api_config.dart`?**
  _High betweenness centrality (0.085) - this node is a cross-community bridge._
- **Why does `ServerConfig` connect `server_card_tile.dart` to `server_form_screen.dart`, `login_contract.dart`, `@immutable`, `manage_servers_screen.dart`, `api_config.dart`, `server_config.dart`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **What connects `ActionType`, `type`, `target` to the rest of the system?**
  _468 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._
- **Should `entity_metadata.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.045454545454545456 - nodes in this community are weakly interconnected._
- **Should `settings_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05398110661268556 - nodes in this community are weakly interconnected._
- **Should `api_client.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05547652916073969 - nodes in this community are weakly interconnected._