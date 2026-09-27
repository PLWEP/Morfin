import 'package:flutter/material.dart';
import '../../features/menu/sub_menu_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/main_shell_screen.dart';
import '../metadata/action_metadata.dart';
import '../metadata/entity_schema_registry.dart';
import '../services/backend_service.dart';
import '../widgets/entity/entity_list_screen.dart';
import '../widgets/menu/module_info_sheet.dart';

class AppActionDispatcher {
  const AppActionDispatcher._();

  static void dispatch(BuildContext context, ActionMetadata? action, {String? fallbackTitle}) {
    if (action == null) return;

    switch (action.type) {
      case ActionType.navigate:
        _handleNavigation(context, action.target, action.params, fallbackTitle);
        break;
      case ActionType.openDialog:
        _handleDialog(context, action.target, action.params);
        break;
      case ActionType.openUrl:
      case ActionType.custom:
        _showToast(context, 'Action "${action.target}" triggered');
        break;
    }
  }

  static void _handleNavigation(
    BuildContext context,
    String target,
    Map<String, dynamic> params,
    String? fallbackTitle,
  ) {
    Widget? targetScreen;
    final lower = target.toLowerCase();

    if (lower == '/submenu') {
      final nodeId = params['nodeId'] as int? ?? 0;
      final title = (params['title'] as String?) ?? fallbackTitle ?? 'Module';
      targetScreen = SubMenuScreen(parentId: nodeId, title: title);
    } else if (lower == '/lobby' || lower == 'lobby') {
      targetScreen = const MainShellScreen(initialIndex: 0);
    } else if (lower == '/settings' || lower == 'settings') {
      targetScreen = const SettingsScreen();
    } else {
      final schema = EntitySchemaRegistry.findByTarget(target);
      if (schema != null) {
        targetScreen = EntityListScreen(
          schema: schema,
          fetchRecords: () => BackendService.instance.fetchEntitySet(
            projection: schema.projection,
            entitySet: schema.entitySet,
          ),
          onExecuteAction: (action, data) => BackendService.instance.executeAction(
            projection: schema.projection,
            actionName: action,
            parameters: data,
          ),
        );
      }
    }

    if (targetScreen != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => targetScreen!));
    } else {
      ModuleInfoSheet.show(
        context,
        title: (params['title'] as String?) ?? fallbackTitle ?? target,
        projection: (params['projection'] as String?) ?? target,
        entitySet: params['entitySet'] as String?,
        client: params['client'] as String?,
      );
    }
  }

  static void _handleDialog(BuildContext context, String target, Map<String, dynamic> params) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(target),
        content: Text(params.isNotEmpty ? params.toString() : 'Dialog content'),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
      ),
    );
  }

  static void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating),
    );
  }
}
