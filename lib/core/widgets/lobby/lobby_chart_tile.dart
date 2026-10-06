import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';
import 'lobby_detail_sheet.dart';

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
      onTap: () => LobbyDetailSheet.show(context, metadata),
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
            if (points.isEmpty)
              Container(
                height: 85,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconData, size: 16, color: colors.onSurfaceMuted),
                    const SizedBox(width: 8),
                    Text(
                      metadata.value != null && metadata.value != '-'
                          ? '${metadata.value} records available (No time-series)'
                          : 'No series data available',
                      style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 85,
                child: isLine
                    ? _buildLineChart(context, colors, accentColor, points)
                    : _buildBarChart(context, colors, accentColor, points),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, AppPalette colors, Color barColor, List<Map<String, dynamic>> points) {
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
                Text(
                  val.toInt().toString(),
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                FractionallySizedBox(
                  heightFactor: heightRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 9, color: colors.onSurfaceMuted),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLineChart(BuildContext context, AppPalette colors, Color lineColor, List<Map<String, dynamic>> points) {
    return CustomPaint(
      painter: _LineChartPainter(points: points, lineColor: lineColor, gradientColor: lineColor.withValues(alpha: 0.15)),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> points;
  final Color lineColor;
  final Color gradientColor;

  _LineChartPainter({required this.points, required this.lineColor, required this.gradientColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxVal = points.fold<double>(1.0, (prev, p) {
      final val = (p['value'] as num?)?.toDouble() ?? 0.0;
      return math.max(prev, val);
    });

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (points.length - 1);
    for (int i = 0; i < points.length; i++) {
      final val = (points[i]['value'] as num?)?.toDouble() ?? 0.0;
      final x = i * stepX;
      final y = size.height - (val / maxVal * (size.height - 10));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevVal = (points[i - 1]['value'] as num?)?.toDouble() ?? 0.0;
        final prevY = size.height - (prevVal / maxVal * (size.height - 10));

        final cp1X = prevX + (x - prevX) / 2;
        final cp2X = prevX + (x - prevX) / 2;
        path.cubicTo(cp1X, prevY, cp2X, y, x, y);
        fillPath.cubicTo(cp1X, prevY, cp2X, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()..color = gradientColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
