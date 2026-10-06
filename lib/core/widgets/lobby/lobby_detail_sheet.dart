import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';

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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
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
            // Drag Handle
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

            // Header Row
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
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                        if (metadata.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            metadata.subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
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

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainMetric(context, colors, accentColor),
                    const SizedBox(height: 16),
                    _buildSpecificSection(context, colors, accentColor),
                    const SizedBox(height: 16),
                    _buildSystemCard(context, colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMetric(BuildContext context, AppPalette colors, Color accentColor) {
    switch (metadata.type) {
      case LobbyElementType.counter:
        return _buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Total Count',
          value: metadata.value ?? '0',
          unit: metadata.unit ?? 'Records',
          badgeText: metadata.change ?? 'Live metrics',
          badgeColor: metadata.isPositive ? colors.statusSuccess : colors.statusCritical,
          isPassing: metadata.isPositive,
        );
      case LobbyElementType.indicator:
        final hasPct = metadata.percentage != null;
        final pct = (metadata.percentage ?? 0.0).clamp(0.0, 100.0);
        final tgt = (metadata.target ?? 100.0).clamp(0.0, 100.0);
        final isPassing = pct >= (tgt * 0.85);
        return _buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Current Ratio',
          value: hasPct ? '${pct.toStringAsFixed(1)}%' : '-',
          unit: 'Target: ${tgt.toInt()}%',
          badgeText: hasPct ? (metadata.change ?? '${pct.toStringAsFixed(1)}%') : 'No Data',
          badgeColor: isPassing ? colors.statusSuccess : colors.statusWarning,
          isPassing: isPassing,
        );
      case LobbyElementType.barChart:
        final pts = metadata.chartPoints;
        final total = pts.fold<double>(0.0, (s, p) => s + ((p['value'] as num?)?.toDouble() ?? 0.0));
        return _buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Cumulative Volume',
          value: total.toInt().toString(),
          unit: 'Units (All Periods)',
          badgeText: '${pts.length} Recorded Periods',
          badgeColor: colors.primary,
          isPassing: true,
        );
      case LobbyElementType.lineChart:
        final pts = metadata.chartPoints;
        final total = pts.fold<double>(0.0, (s, p) => s + ((p['value'] as num?)?.toDouble() ?? 0.0));
        final avg = pts.isEmpty ? 0 : (total / pts.length).round();
        return _buildMetricCard(
          colors: colors,
          accentColor: accentColor,
          label: 'Throughput',
          value: '$avg',
          unit: 'Avg Lines / Day',
          badgeText: '7-Day Flow Period',
          badgeColor: colors.primary,
          isPassing: true,
        );
      case LobbyElementType.unknown:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMetricCard({
    required AppPalette colors,
    required Color accentColor,
    required String label,
    required String value,
    required String unit,
    required String badgeText,
    required Color badgeColor,
    required bool isPassing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.onSurfaceMuted),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  badgeText,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificSection(BuildContext context, AppPalette colors, Color accentColor) {
    switch (metadata.type) {
      case LobbyElementType.indicator:
        return _buildIndicatorDetails(colors, accentColor);
      case LobbyElementType.barChart:
      case LobbyElementType.lineChart:
        return _buildChartBreakdown(colors, accentColor);
      case LobbyElementType.counter:
      case LobbyElementType.unknown:
        return _buildCounterDetails(colors);
    }
  }

  Widget _buildIndicatorDetails(AppPalette colors, Color barColor) {
    final pct = (metadata.percentage ?? 0.0).clamp(0.0, 100.0);
    final tgt = (metadata.target ?? 100.0).clamp(0.0, 100.0);
    final variance = pct - tgt;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compliance Progress & Variance',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (pct / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailRowItem(colors, 'Target Limit', '${tgt.toInt()}%'),
              _detailRowItem(colors, 'Achieved', '${pct.toStringAsFixed(1)}%'),
              _detailRowItem(
                colors,
                'Variance',
                '${variance >= 0 ? '+' : ''}${variance.toStringAsFixed(1)}%',
                valColor: variance >= 0 ? colors.statusSuccess : colors.statusWarning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBreakdown(AppPalette colors, Color accentColor) {
    final pts = metadata.chartPoints;
    if (pts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data Points Breakdown',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface),
              ),
              Text(
                '${pts.length} Entries',
                style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...pts.map((p) {
            final label = p['label']?.toString() ?? '-';
            final val = (p['value'] as num?)?.toDouble() ?? 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurface),
                  ),
                  const Spacer(),
                  Text(
                    val.toInt().toString(),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.onSurface),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCounterDetails(AppPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Query & Filter Criteria',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface),
          ),
          const SizedBox(height: 8),
          _detailRow(colors, 'Target Projection', metadata.targetProjection ?? 'IFS Cloud'),
          _detailRow(colors, 'Entity Set', metadata.targetEndpoint ?? 'PurchaseRequisitionSet'),
          _detailRow(colors, 'Filter Conditions', metadata.filterConditions ?? "Objstate eq 'Released'"),
          _detailRow(colors, 'Refresh Interval', 'On Demand / Pull-to-refresh'),
        ],
      ),
    );
  }

  Widget _buildSystemCard(BuildContext context, AppPalette colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Widget Specification',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceMuted),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _specItem(colors, 'Element ID', '#${metadata.id}'),
              _specItem(colors, 'Type', metadata.type.name.toUpperCase()),
              _specItem(colors, 'Grid Span', '${metadata.span.col} Col'),
              _specItem(colors, 'Status', 'Active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(AppPalette colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted)),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRowItem(AppPalette colors, String label, String value, {Color? valColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: colors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: valColor ?? colors.onSurface),
        ),
      ],
    );
  }

  Widget _specItem(AppPalette colors, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: colors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
