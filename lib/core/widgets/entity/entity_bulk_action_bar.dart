import 'package:flutter/material.dart';
import 'entity_bulk_action_runner.dart';

class EntityBulkActionBar extends StatelessWidget {
  final List<Map<String, dynamic>> childActions;
  final List<Map<String, dynamic>> selectedRecords;
  final String fallbackProjection;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;
  final VoidCallback onSuccess;

  const EntityBulkActionBar({
    super.key,
    required this.childActions,
    required this.selectedRecords,
    required this.fallbackProjection,
    this.onExecuteAction,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: childActions.map((act) {
          final label = (act['Label'] ?? act['CleanLabel'] ?? 'Action').toString();
          final targetUrl = act['TargetUrl'] as String?;
          final parts = (targetUrl ?? '').split('.svc/');
          final proj = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : fallbackProjection;
          final actionName = parts.length > 1 ? parts[1].split('?')[0] : label;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton.tonal(
                onPressed: () => EntityBulkActionRunner.execute(
                  context: context,
                  label: label,
                  actionName: actionName,
                  projection: proj,
                  records: selectedRecords,
                  onExecuteAction: onExecuteAction,
                  onSuccess: onSuccess,
                ),
                child: Text('$label (${selectedRecords.length})', maxLines: 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
