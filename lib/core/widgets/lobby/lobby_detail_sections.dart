import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';

class LobbyDetailSections {
  const LobbyDetailSections._();

  static Widget buildMetricCard({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceMuted)),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: colors.onSurface, letterSpacing: -1)),
                  const SizedBox(width: 6),
                  Text(unit, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurfaceMuted)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(badgeText, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSpecificSection(LobbyElementMetadata metadata, AppPalette colors, Color accentColor) {
    Widget child;
    if (metadata.type == LobbyElementType.indicator) {
      final hasPct = metadata.percentage != null;
      final pct = (metadata.percentage ?? 0.0).clamp(0.0, 100.0);
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Proportion Breakdown', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(4))),
              FractionallySizedBox(
                widthFactor: hasPct ? (pct / 100).clamp(0.0, 1.0) : 0.0,
                child: Container(height: 8, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(4))),
              ),
            ],
          ),
        ],
      );
    } else if (metadata.type == LobbyElementType.barChart || metadata.type == LobbyElementType.lineChart) {
      final pts = metadata.chartPoints;
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Period Data Status', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
          const SizedBox(height: 12),
          if (pts.isEmpty)
            Text('No time-series periods configured on endpoint ${metadata.targetEndpoint ?? ""}.', style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted))
          else
            ...pts.map((pt) => detailRow(colors, pt['label']?.toString() ?? '', '${pt['value'] ?? 0}')),
        ],
      );
    } else {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Query & Filter Criteria', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
          const SizedBox(height: 8),
          detailRow(colors, 'Projection', metadata.targetProjection ?? '-'),
          detailRow(colors, 'Target Endpoint', metadata.targetEndpoint ?? '-'),
          detailRow(colors, 'Filter Conditions', metadata.filterConditions ?? 'No filter'),
          detailRow(colors, 'Refresh Interval', 'On Demand / Pull-to-refresh'),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }

  static Widget buildSystemCard(LobbyElementMetadata metadata, AppPalette colors) {
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
          Text('Widget Specification', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceMuted)),
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

  static Widget detailRow(AppPalette colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted)),
          Flexible(
            child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  static Widget _specItem(AppPalette colors, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: colors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant)),
      ],
    );
  }
}
