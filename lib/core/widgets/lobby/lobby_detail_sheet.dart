import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';
import 'lobby_detail_sections.dart';

class LobbyDetailSheet extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyDetailSheet({super.key, required this.metadata});

  static void show(BuildContext context, LobbyElementMetadata metadata) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LobbyDetailSheet(metadata: metadata),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final accentColor = ColorResolver.resolve(metadata.colorToken, context, fallback: colors.primary);
    final iconData = IconResolver.resolve(metadata.icon, fallback: Icons.analytics_outlined);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.78),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, size: 20, color: accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metadata.title,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface),
                        ),
                        if (metadata.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(metadata.subtitle!, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: colors.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 18,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.6)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainMetric(colors, accentColor),
                    const SizedBox(height: 16),
                    LobbyDetailSections.buildSpecificSection(metadata, colors, accentColor),
                    const SizedBox(height: 16),
                    LobbyDetailSections.buildSystemCard(metadata, colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMetric(AppPalette colors, Color accentColor) {
    switch (metadata.type) {
      case LobbyElementType.counter:
        return LobbyDetailSections.buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Total Count',
          value: metadata.value ?? '-',
          unit: metadata.unit ?? 'Records',
          badgeText: metadata.isPositive ? '${metadata.value ?? 0} Records' : 'Sync error',
          badgeColor: metadata.isPositive ? colors.statusSuccess : colors.statusCritical,
          isPassing: metadata.isPositive,
        );
      case LobbyElementType.indicator:
        final hasPct = metadata.percentage != null;
        final pct = (metadata.percentage ?? 0.0).clamp(0.0, 100.0);
        return LobbyDetailSections.buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Current Ratio',
          value: hasPct ? '${pct.toStringAsFixed(1)}%' : '-',
          unit: metadata.subtitle ?? 'Proportion',
          badgeText: hasPct ? (metadata.change ?? '${pct.toStringAsFixed(1)}%') : 'No Data',
          badgeColor: hasPct ? colors.statusSuccess : colors.statusCritical,
          isPassing: hasPct,
        );
      case LobbyElementType.barChart:
      case LobbyElementType.lineChart:
        return LobbyDetailSections.buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'TimeSeries Metric',
          value: metadata.value ?? '-',
          unit: metadata.unit ?? 'Points',
          badgeText: '${metadata.chartPoints.length} periods',
          badgeColor: accentColor,
          isPassing: metadata.chartPoints.isNotEmpty,
        );
      case LobbyElementType.unknown:
        return const SizedBox.shrink();
    }
  }
}
