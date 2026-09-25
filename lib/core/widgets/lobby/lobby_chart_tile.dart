import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../navigation/action_dispatcher.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';

class LobbyChartTile extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyChartTile({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iconData = IconResolver.resolve(metadata.icon, fallback: Icons.bar_chart_rounded);
    final accentColor = ColorResolver.resolve(metadata.colorToken, context, fallback: colors.primary);

    return InkWell(
      onTap: () => AppActionDispatcher.dispatch(context, metadata.action, fallbackTitle: metadata.title),
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
                Row(
                  children: [
                    Icon(iconData, size: 16, color: accentColor),
                    const SizedBox(width: 8),
                    Text(
                      metadata.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
                if (metadata.subtitle != null)
                  Text(
                    metadata.subtitle!,
                    style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 70,
              child: _buildBarChart(context, colors, accentColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, AppPalette colors, Color barColor) {
    final points = metadata.chartPoints;
    if (points.isEmpty) {
      return Center(
        child: Text('No chart data', style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted)),
      );
    }

    final maxVal = points.fold<double>(1.0, (prev, p) {
      final val = (p['value'] as num?)?.toDouble() ?? 0.0;
      return math.max(prev, val);
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: points.map((pt) {
        final label = pt['label']?.toString() ?? '';
        final val = (pt['value'] as num?)?.toDouble() ?? 0.0;
        final heightRatio = (val / maxVal).clamp(0.1, 1.0);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: heightRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: barColor.withValues(alpha: 0.85),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 9, color: colors.onSurfaceMuted),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
