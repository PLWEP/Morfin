import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../utils/icon_resolver.dart';
import 'record_action_executor.dart';

class RecordActionRunner {
  const RecordActionRunner._();

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
                      RecordActionExecutor.triggerFormAction(
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
                      RecordActionExecutor.triggerDirectAction(
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
}
