import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../utils/column_config_parser.dart';

class RecordCard extends StatelessWidget {
  final EntitySchemaMetadata schema;
  final Map<String, dynamic> record;
  final String? columnConfig;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  const RecordCard({
    super.key,
    required this.schema,
    required this.record,
    this.columnConfig,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cardMeta = schema.listCard;
    final cfg = (columnConfig != null && columnConfig!.isNotEmpty) ? ColumnConfig.parse(columnConfig) : null;

    final titleKey = cfg != null ? cfg.titleField : (cardMeta.codeField.isNotEmpty ? cardMeta.codeField : 'Id');
    final titleLabel = _resolveLabel(titleKey);
    final title = cfg != null
        ? (record[cfg.titleField] ?? '').toString()
        : (record[cardMeta.codeField] ?? record['OrderNo'] ?? record['PartNo'] ?? record['Id'] ?? (record.isNotEmpty ? record.values.first : '')).toString();

    final subtitleKey = cfg != null ? cfg.subtitleField : (cardMeta.primaryField != cardMeta.codeField ? cardMeta.primaryField : null);
    final subtitleLabel = subtitleKey != null ? _resolveLabel(subtitleKey) : null;
    final subtitle = subtitleKey != null ? record[subtitleKey]?.toString() : null;

    final detailPairs = <(String label, String value)>[];
    if (cfg != null && cfg.detailFields.isNotEmpty) {
      for (final fieldKey in cfg.detailFields) {
        final val = record[fieldKey];
        if (val != null && val.toString().trim().isNotEmpty) {
          detailPairs.add((_resolveLabel(fieldKey), val.toString().trim()));
        }
      }
    } else {
      for (final key in [cardMeta.secondaryField, cardMeta.tertiaryField, cardMeta.metricField]) {
        if (key != null && record[key] != null && record[key].toString().trim().isNotEmpty) {
          detailPairs.add((_resolveLabel(key), record[key].toString().trim()));
        }
      }
    }

    final status = cardMeta.statusField != null ? record[cardMeta.statusField]?.toString() : null;
    final (badgeBg, badgeFg) = _resolveStatusColor(status, colors);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.08) : colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? colors.primary : colors.surfaceBorder, width: isSelected ? 1.5 : 1),
        ),
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
                            Text(
                              titleLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.outline),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title.isNotEmpty ? title : '-',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface, height: 1.25),
                            ),
                          ],
                        ),
                      ),
                      if (status != null && status.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                          child: Text(status.toUpperCase(), style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: badgeFg, letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null && subtitle.trim().isNotEmpty && subtitle != title) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitleLabel ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.outline),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant),
                    ),
                  ],
                  if (detailPairs.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Divider(height: 1, thickness: 0.75, color: colors.surfaceBorder.withValues(alpha: 0.7)),
                    const SizedBox(height: 8),
                    Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FixedColumnWidth(10),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.top,
                      children: [
                        for (int i = 0; i < detailPairs.length; i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                child: Text(
                                  detailPairs[i].$1,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                child: Text(':', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: i > 0 ? 5 : 0),
                                child: Text(
                                  detailPairs[i].$2,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.onSurface),
                                ),
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
    );
  }

  String _resolveLabel(String key) {
    for (final f in schema.fields) {
      if (f.key.toLowerCase() == key.toLowerCase()) return f.label;
    }
    final formatted = key.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (m) => ' ${m.group(0)}');
    return formatted.replaceAll('_', ' ').trim();
  }

  (Color, Color) _resolveStatusColor(String? status, AppPalette colors) {
    if (status == null) return (colors.surfaceContainerHigh, colors.outline);
    final s = status.toLowerCase();
    if (s.contains('progress') || s.contains('active')) return (colors.statusActive.withValues(alpha: 0.12), colors.statusActive);
    if (s.contains('pending') || s.contains('low') || s.contains('warn')) return (colors.statusWarning.withValues(alpha: 0.12), colors.statusWarning);
    if (s.contains('crit') || s.contains('out') || s.contains('error')) return (colors.statusCritical.withValues(alpha: 0.12), colors.statusCritical);
    if (s.contains('done') || s.contains('complete') || s.contains('in stock')) return (colors.statusSuccess.withValues(alpha: 0.12), colors.statusSuccess);
    return (colors.surfaceContainerHigh, colors.outline);
  }
}
