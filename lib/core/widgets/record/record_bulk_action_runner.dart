import 'package:flutter/material.dart';
import '../../services/backend_service.dart';
import 'record_action_executor.dart';

class RecordBulkActionRunner {
  const RecordBulkActionRunner._();

  static Future<void> execute({
    required BuildContext context,
    required String label,
    required String actionName,
    required String projection,
    required List<Map<String, dynamic>> records,
    Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
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

    try {
      final res = await BackendService.instance.executeBatchAction(
        targetProjection: projection,
        actionName: actionName,
        items: records,
      );

      final success = res['SuccessCount'] as int? ?? count;
      final fail = res['FailCount'] as int? ?? 0;

      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      onSuccess();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(fail == 0
                ? 'Bulk $label completed: All $success items succeeded.'
                : 'Bulk $label completed: $success succeeded, $fail failed.'),
            backgroundColor: fail == 0 ? Colors.green.shade800 : Colors.orange.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      final errorMsg = RecordActionExecutor.extractErrorMessage(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Batch failed: $errorMsg'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
