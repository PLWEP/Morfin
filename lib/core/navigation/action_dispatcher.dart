import 'package:flutter/material.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../metadata/action_metadata.dart';
import '../metadata/mock_entity_service.dart';
import '../widgets/entity/generic_entity_list_screen.dart';

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
        _showNotification(context, 'Action "${action.target}" triggered');
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

    switch (target.toLowerCase()) {
      case '/work_orders':
      case 'work_orders':
      case 'wo_exec':
        targetScreen = GenericEntityListScreen(
          schema: MockEntityService.workOrderSchema,
          fetchRecords: MockEntityService.fetchLiveWorkOrders,
          onExecuteAction: MockEntityService.executeWorkOrderAction,
        );
        break;
      case '/inventory':
      case 'inventory':
      case 'inv_part':
        targetScreen = GenericEntityListScreen(
          schema: MockEntityService.inventorySchema,
          fetchRecords: MockEntityService.fetchLiveInventory,
          onExecuteAction: MockEntityService.executeInventoryAction,
        );
        break;
      case '/notifications':
      case 'notifications':
        targetScreen = const NotificationsScreen();
        break;
      case '/settings':
      case 'settings':
        targetScreen = const SettingsScreen();
        break;
    }

    if (targetScreen != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => targetScreen!),
      );
    } else {
      final label = fallbackTitle ?? target;
      _showNotification(context, '$label is coming soon in IFS Cloud Mobile');
    }
  }

  static void _handleDialog(BuildContext context, String target, Map<String, dynamic> params) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(target),
        content: Text(params.isNotEmpty ? params.toString() : 'Dialog content'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
