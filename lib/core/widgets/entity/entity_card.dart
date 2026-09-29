import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';

import '../../utils/column_config_parser.dart';

class EntityCard extends StatelessWidget {
  final EntitySchemaMetadata schema;
  final Map<String, dynamic> record;
  final String? columnConfig;
  final VoidCallback? onTap;

  const EntityCard({
    super.key,
    required this.schema,
    required this.record,
    this.columnConfig,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cardMeta = schema.listCard;
    final cfg = (columnConfig != null && columnConfig!.isNotEmpty)
        ? ColumnConfig.parse(columnConfig)
        : null;

    final code = cfg != null
        ? (record[cfg.titleField] ?? '').toString()
        : (record[cardMeta.codeField] ??
                record['OrderNo'] ??
                record['PartNo'] ??
                record['Id'] ??
                (record.isNotEmpty ? record.values.first : ''))
            .toString();

    final title = cfg != null
        ? (cfg.subtitleField != null ? record[cfg.subtitleField]?.toString() ?? code : code)
        : (record[cardMeta.primaryField] ??
                record['Description'] ??
                record['Title'] ??
                record['Name'] ??
                record['ErrDescr'] ??
                (record.length > 1 ? record.values.elementAt(1) : code))
            .toString();

    final secondary = cfg != null
        ? (cfg.detailFields.isNotEmpty ? record[cfg.detailFields[0]]?.toString() : null)
        : (cardMeta.secondaryField != null ? record[cardMeta.secondaryField]?.toString() : null);

    final tertiary = cfg != null
        ? (cfg.detailFields.length > 1 ? record[cfg.detailFields[1]]?.toString() : null)
        : (cardMeta.tertiaryField != null ? record[cardMeta.tertiaryField]?.toString() : null);

    final metric = cfg != null
        ? (cfg.detailFields.length > 2 ? record[cfg.detailFields[2]]?.toString() : null)
        : (cardMeta.metricField != null ? record[cardMeta.metricField]?.toString() : null);

    final status = cardMeta.statusField != null ? record[cardMeta.statusField]?.toString() : null;
    final (badgeBg, badgeFg) = _resolveStatusColor(status, colors);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  code,
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: badgeFg,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (secondary != null) ...[
                  Icon(Icons.precision_manufacturing_outlined, size: 14, color: colors.outline),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      secondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (tertiary != null) ...[
                  Icon(Icons.location_on_outlined, size: 14, color: colors.outline),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      tertiary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant),
                    ),
                  ),
                ],
                const Spacer(),
                if (metric != null)
                  Text(
                    metric,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.outline,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
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
