import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../utils/column_config_parser.dart';
import 'record_status_badge.dart';

class RecordCard extends StatelessWidget {
  final EntitySchemaMetadata schema;
  final Map<String, dynamic> record;
  final String? columnConfig;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDetailTap;
  final bool isSelectionMode;
  final bool isSelected;

  const RecordCard({
    super.key,
    required this.schema,
    required this.record,
    this.columnConfig,
    this.onTap,
    this.onLongPress,
    this.onDetailTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cardMeta = schema.listCard;
    final cfg = (columnConfig != null && columnConfig!.isNotEmpty) ? ColumnConfig.parse(columnConfig) : null;

    final titleKey = cfg?.titleField ?? (cardMeta.codeField.isNotEmpty ? cardMeta.codeField : 'Id');
    final titleLabel = _resolveLabel(titleKey);
    final title = (cfg != null ? record[cfg.titleField] : (record[cardMeta.codeField] ?? record['OrderNo'] ?? record['PartNo'] ?? record['Id'] ?? (record.isNotEmpty ? record.values.first : '')) ?? '').toString();

    final subtitleKey = cfg?.subtitleField ?? (cardMeta.primaryField != cardMeta.codeField ? cardMeta.primaryField : null);
    final subtitleLabel = subtitleKey != null ? _resolveLabel(subtitleKey) : null;
    final subtitle = subtitleKey != null ? record[subtitleKey]?.toString() : null;

    final detailPairs = <(String label, String value)>[];
    final fieldsToCheck = (cfg != null && cfg.detailFields.isNotEmpty) ? cfg.detailFields : [cardMeta.secondaryField, cardMeta.tertiaryField, cardMeta.metricField].whereType<String>();
    for (final key in fieldsToCheck) {
      final val = record[key]?.toString().trim();
      if (val != null && val.isNotEmpty) detailPairs.add((_resolveLabel(key), val));
    }

    final status = cardMeta.statusField != null ? record[cardMeta.statusField]?.toString() : null;

    return Material(
      color: isSelected ? colors.primary.withValues(alpha: 0.08) : colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? colors.primary : colors.surfaceBorder, width: isSelected ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSelectionMode) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSelected ? colors.primary : colors.outline, size: 20),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(titleLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.outline)),
                                  const SizedBox(height: 2),
                                  Text(title.isNotEmpty ? title : '-', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface, height: 1.25)),
                                ],
                              ),
                            ),
                            if (status != null && status.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              RecordStatusBadge(status: status),
                            ],
                          ],
                        ),
                        if (subtitle != null && subtitle.trim().isNotEmpty && subtitle != title) ...[
                          const SizedBox(height: 6),
                          Text(subtitleLabel ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.outline)),
                          const SizedBox(height: 1),
                          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant)),
                        ],
                        if (detailPairs.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Divider(height: 1, thickness: 0.75, color: colors.surfaceBorder.withValues(alpha: 0.7)),
                          const SizedBox(height: 8),
                          Table(
                            columnWidths: const {0: IntrinsicColumnWidth(), 1: FixedColumnWidth(10), 2: FlexColumnWidth()},
                            defaultVerticalAlignment: TableCellVerticalAlignment.top,
                            children: [
                              for (int i = 0; i < detailPairs.length; i++)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                      child: Text(detailPairs[i].$1, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                      child: Text(':', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                      child: Text(detailPairs[i].$2, textAlign: TextAlign.end, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.onSurface)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onDetailTap != null && !isSelectionMode) ...[
            Divider(height: 1, thickness: 1, color: colors.surfaceBorder),
            InkWell(
              onTap: onDetailTap,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_outlined, size: 15, color: colors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'View Details',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded, size: 15, color: colors.primary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _resolveLabel(String key) {
    for (final f in schema.fields) {
      if (f.key.toLowerCase() == key.toLowerCase()) return f.label;
    }
    final formatted = key.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (m) => ' ${m.group(0)}');
    return formatted.replaceAll('_', ' ').trim();
  }
}
