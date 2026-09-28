import 'package:flutter/material.dart';
import '../../features/menu/sub_menu_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/main_shell_screen.dart';
import '../metadata/action_metadata.dart';
import '../metadata/entity_metadata.dart';
import '../metadata/entity_schema_registry.dart';
import '../network/odata_query.dart';
import '../services/backend_service.dart';
import '../widgets/entity/entity_list_screen.dart';
import '../widgets/menu/module_info_sheet.dart';
import '../widgets/menu/sub_menu_bottom_sheet.dart';

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
    final lower = target.toLowerCase();

    if (lower == '/bottom_sheet') {
      final nodeId = params['nodeId'] ?? '0';
      final title = (params['title'] as String?) ?? fallbackTitle ?? 'Menu';
      SubMenuBottomSheet.show(context, title: title, parentId: nodeId);
      return;
    }

    if (lower == '/submenu') {
      final nodeId = params['nodeId'] ?? '0';
      final title = (params['title'] as String?) ?? fallbackTitle ?? 'Module';
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubMenuScreen(parentId: nodeId, title: title)),
      );
      return;
    }

    if (lower == '/lobby' || lower == 'lobby') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MainShellScreen(initialIndex: 0)),
      );
      return;
    }

    if (lower == '/settings' || lower == 'settings') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
      return;
    }

    final projection = (params['projection'] as String?) ?? target;
    final entitySet = params['entitySet'] as String?;
    final defaultFilter = params['defaultFilter'] as String?;
    final title = (params['title'] as String?) ?? fallbackTitle ?? projection;

    final schema = EntitySchemaRegistry.findByTarget(target) ??
        EntitySchemaRegistry.findByTarget(projection) ??
        (entitySet != null
            ? EntitySchemaMetadata(
                entityName: title,
                title: title,
                icon: 'layers',
                projection: projection,
                entitySet: entitySet,
                fields: const [],
                listCard: const EntityListCardMetadata(
                  codeField: 'OrderNo',
                  primaryField: 'Description',
                  secondaryField: 'Status',
                ),
              )
            : null);

    if (schema != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EntityListScreen(
            schema: schema,
            fetchRecords: ({int skip = 0, int top = 20}) => BackendService.instance.fetchEntitySet(
              projection: schema.projection,
              entitySet: schema.entitySet,
              query: ODataQuery(
                filter: defaultFilter != null && defaultFilter.isNotEmpty ? defaultFilter : null,
                top: top,
                skip: skip,
              ),
            ),
            onExecuteAction: (action, data) => BackendService.instance.executeAction(
              projection: schema.projection,
              actionName: action,
              parameters: data,
            ),
          ),
        ),
      );
    } else {
      ModuleInfoSheet.show(
        context,
        title: title,
        projection: projection,
        entitySet: entitySet,
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
