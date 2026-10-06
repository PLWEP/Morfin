import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../navigation/action_dispatcher.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';
import '../sparkline_painter.dart';

class LobbyChartTile extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyChartTile({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isLine = metadata.type == LobbyElementType.lineChart;
    final fallbackIcon = isLine ? Icons.show_chart_rounded : Icons.bar_chart_rounded;
    final iconData = IconResolver.resolve(metadata.icon, fallback: fallbackIcon);
    final accentColor = ColorResolver.resolve(metadata.colorToken, context, fallback: colors.primary);
    final points = metadata.chartPoints;

    return InkWell(
      onTap: () => AppActionDispatcher.dispatch(context, metadata.action, fallbackTitle: metadata.title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData, size: 15, color: accentColor),
                    ),
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
                if (metadata.subtitle != null && metadata.subtitle!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      metadata.subtitle!,
                      style: GoogleFonts.inter(fontSize: 10, color: colors.onSurfaceMuted),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 85,
              child: points.isEmpty
                  ? Center(
                      child: Text(
                        'No chart points received',
                        style: TextStyle(color: colors.outline, fontSize: 11),
                      ),
                    )
                  : (isLine
                      ? _buildLineChart(colors, accentColor, points)
                      : _buildBarChart(colors, accentColor, points)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(AppPalette colors, Color barColor, List<Map<String, dynamic>> points) {
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
        final heightRatio = (val / maxVal).clamp(0.12, 1.0);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [barColor, barColor.withValues(alpha: 0.65)],
                          ),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: colors.onSurfaceMuted),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLineChart(AppPalette colors, Color lineColor, List<Map<String, dynamic>> points) {
    final values = points.map((p) => (p['value'] as num?)?.toDouble() ?? 0.0).toList();

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: SparklinePainter(data: values, lineColor: lineColor, strokeWidth: 2.2),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: points.map((p) {
            return Text(
              p['label']?.toString() ?? '',
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: colors.onSurfaceMuted),
            );
          }).toList(),
        ),
      ],
    );
  }
}
