import 'package:flutter/material.dart';
import '../../services/backend_service.dart';
import 'entity_action_executor.dart';

class EntityBulkActionRunner {
  const EntityBulkActionRunner._();

  static Future<void> execute({
    required BuildContext context,
    required String label,
    required String actionName,
    required String projection,
    required List<Map<String, dynamic>> records,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onSuccess,
  }) async {
    final count = records.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Execute $label?'),
        content: Text('Are you sure you want to execute "$label" on $count selected items?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Execute ($count)')),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    int successCount = 0;
    for (final record in records) {
      try {
        final payload = EntityActionExecutor.sanitizePayload(record);
        if (onExecuteAction != null) {
          await onExecuteAction(actionName, payload);
        } else {
          await BackendService.instance.executeAction(
            projection: projection,
            actionName: actionName,
            parameters: payload,
          );
        }
        successCount++;
      } catch (e) {
        debugPrint('Failed to execute bulk action on record: $e');
      }
    }

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    onSuccess();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulk $label completed: $successCount of $count succeeded'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
