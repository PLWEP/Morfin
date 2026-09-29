import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../services/backend_service.dart';
import '../../utils/icon_resolver.dart';
import 'entity_action_sheet.dart';

class EntityActionRunner {
  const EntityActionRunner._();

  static void showChildActionsSheet(
    BuildContext context, {
    required EntitySchemaMetadata schema,
    required Map<String, dynamic> record,
    required List<Map<String, dynamic>> actions,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) {
    final colors = AppColors.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Available Actions',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface),
              ),
              const SizedBox(height: 12),
              ...actions.map((act) {
                final label = (act['Label'] ?? act['CleanLabel'] ?? 'Action').toString();
                final actType = (act['ActionType'] as String?)?.toUpperCase() ?? 'ACTION';
                final iconName = act['Icon'] as String?;
                final targetUrl = act['TargetUrl'] as String?;
                final (parsedProj, parsedEndpoint) = _parseTarget(targetUrl);
                final projection = parsedProj ?? schema.projection;
                final actionName = parsedEndpoint ?? act['TargetEndpoint'] as String? ?? label;

                return ListTile(
                  leading: Icon(
                    iconName != null ? IconResolver.resolve(iconName) : Icons.play_arrow_rounded,
                    color: colors.primary,
                  ),
                  title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface)),
                  trailing: Icon(Icons.chevron_right_rounded, size: 20, color: colors.outline),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    if (actType == 'FORM') {
                      _triggerFormAction(
                        context,
                        schema: schema,
                        record: record,
                        title: label,
                        projection: projection,
                        actionName: actionName,
                        onExecuteAction: onExecuteAction,
                        onRefresh: onRefresh,
                      );
                    } else {
                      _triggerDirectAction(
                        context,
                        label: label,
                        record: record,
                        projection: projection,
                        actionName: actionName,
                        onExecuteAction: onExecuteAction,
                        onRefresh: onRefresh,
                      );
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  static (String?, String?) _parseTarget(String? targetUrl) {
    if (targetUrl == null || !targetUrl.contains('.svc/')) return (null, null);
    final parts = targetUrl.split('.svc/');
    final p = parts[0].replaceAll('/', '').trim();
    final e = parts[1].split('?')[0].replaceAll('/', '').trim();
    return (p.isNotEmpty ? p : null, e.isNotEmpty ? e : null);
  }

  static Future<void> _triggerDirectAction(
    BuildContext context, {
    required String label,
    required Map<String, dynamic> record,
    required String projection,
    required String actionName,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Execute $label?'),
        content: Text('Are you sure you want to execute "$label"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Execute')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (onExecuteAction != null) {
        await onExecuteAction(actionName, record);
      } else {
        await BackendService.instance.executeAction(
          projection: projection,
          actionName: actionName,
          parameters: record,
        );
      }
      messenger.showSnackBar(
        SnackBar(content: Text('"$label" completed successfully'), behavior: SnackBarBehavior.floating),
      );
      onRefresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Action failed: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    }
  }

  static void _triggerFormAction(
    BuildContext context, {
    required EntitySchemaMetadata schema,
    required Map<String, dynamic> record,
    required String title,
    required String projection,
    required String actionName,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) {
    final formFields = schema.fields.where((f) => !f.isKey).take(4).toList();

    EntityActionSheet.show(
      context,
      title: title,
      actionLabel: 'Submit',
      fields: formFields,
      initialValues: record,
      onSubmit: (values) async {
        final payload = <String, dynamic>{...record, ...values};
        if (onExecuteAction != null) {
          await onExecuteAction(actionName, payload);
        } else {
          await BackendService.instance.executeAction(
            projection: projection,
            actionName: actionName,
            parameters: payload,
          );
        }
        onRefresh();
      },
    );
  }
}
