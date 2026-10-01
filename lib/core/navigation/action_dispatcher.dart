import 'package:flutter/material.dart';
import '../../features/menu/sub_menu_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/main_shell_screen.dart';
import '../metadata/action_metadata.dart';
import '../metadata/entity_metadata.dart';
import '../metadata/entity_schema_registry.dart';
import '../network/data_query.dart';
import '../services/backend_service.dart';
import '../widgets/menu/module_info_sheet.dart';
import '../widgets/menu/sub_menu_bottom_sheet.dart';
import '../widgets/record/record_action_executor.dart';
import '../widgets/record/record_list_screen.dart';

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
      SubMenuBottomSheet.show(context, title: (params['title'] as String?) ?? fallbackTitle ?? 'Menu', parentId: params['nodeId'] ?? '0');
      return;
    }
    if (lower == '/submenu') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SubMenuScreen(parentId: params['nodeId'] ?? '0', title: (params['title'] as String?) ?? fallbackTitle ?? 'Module')));
      return;
    }
    if (lower == '/lobby' || lower == 'lobby') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MainShellScreen(initialIndex: 0)));
      return;
    }
    if (lower == '/settings' || lower == 'settings') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
      return;
    }

    var projection = params['projection'] as String?;
    var entitySet = params['entitySet'] as String?;
    final targetUrl = params['targetUrl'] as String?;
    if ((projection == null || entitySet == null) && targetUrl != null && targetUrl.contains('.svc/')) {
      final parts = targetUrl.split('.svc/');
      projection ??= parts[0].replaceAll('/', '').trim();
      entitySet ??= parts[1].split('?')[0].replaceAll('/', '').trim();
    }
    projection ??= target;

    final defaultFilter = params['defaultFilter'] as String?;
    final title = (params['title'] as String?) ?? fallbackTitle ?? projection;
    final nodeId = (params['nodeId'] ?? '').toString();
    final columnConfig = params['columnConfig'] as String?;
    final paramConfig = params['paramConfig'] as String?;
    final itemClickAction = params['itemClickAction'] as String?;
    final itemClickTarget = params['itemClickTarget'] as String?;
    final itemClickFields = params['itemClickFields'] as String?;
    final actionType = (params['actionType'] as String?)?.toUpperCase() ?? 'LIST';
    final targetEndpoint = (params['targetEndpoint'] as String?) ?? entitySet ?? title;

    if (actionType == 'FORM_DIALOG' || actionType == 'FORM DIALOG' || actionType == 'FORM') {
      final fallback = EntitySchemaMetadata(
        entityName: title, title: title, icon: 'edit_note', projection: projection, entitySet: entitySet ?? '',
        fields: const [], listCard: const EntityListCardMetadata(codeField: '', primaryField: '', secondaryField: ''),
      );
      RecordActionExecutor.triggerFormAction(
        context, schema: EntitySchemaRegistry.findByTarget(projection) ?? fallback,
        record: const {}, title: title, projection: projection, actionName: targetEndpoint, paramConfig: paramConfig, onRefresh: () {},
      );
      return;
    }

    if (actionType == 'ACTION') {
      RecordActionExecutor.triggerDirectAction(
        context, label: title, record: const {}, projection: projection, actionName: targetEndpoint, onRefresh: () {},
      );
      return;
    }

    final schema = EntitySchemaRegistry.findByTarget(target) ??
        EntitySchemaRegistry.findByTarget(projection) ??
        (entitySet != null
            ? EntitySchemaMetadata(
                entityName: title, title: title, icon: 'layers', projection: projection, entitySet: entitySet, fields: const [],
                listCard: const EntityListCardMetadata(codeField: 'OrderNo', primaryField: 'Description', secondaryField: 'Status'),
              )
            : null);

    if (schema != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => RecordListScreen(
          schema: schema,
          nodeId: nodeId,
          columnConfig: columnConfig,
          itemClickAction: itemClickAction,
          itemClickTarget: itemClickTarget,
          itemClickFields: itemClickFields,
          fetchRecords: ({int skip = 0, int top = 20}) => BackendService.instance.fetchEntitySet(
            projection: schema.projection,
            entitySet: schema.entitySet,
            query: DataQuery(filter: DataQuery.combineFilters(defaultFilter: defaultFilter), top: top, skip: skip),
          ),
          onExecuteAction: (action, data) => BackendService.instance.executeAction(
            projection: schema.projection,
            actionName: action,
            parameters: data,
          ),
        ),
      ));
    } else {
      ModuleInfoSheet.show(context, title: title, projection: projection, entitySet: entitySet, client: params['client'] as String?);
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

  static void _showToast(BuildContext context, String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
}
