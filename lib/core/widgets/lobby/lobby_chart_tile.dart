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

  List<Map<String, dynamic>> _resolvePoints(bool isLine) {
    if (metadata.chartPoints.isNotEmpty) return metadata.chartPoints;
    if (isLine) {
      return const [
        {'label': 'Mon', 'value': 28},
        {'label': 'Tue', 'value': 42},
        {'label': 'Wed', 'value': 35},
        {'label': 'Thu', 'value': 68},
        {'label': 'Fri', 'value': 85},
        {'label': 'Sat', 'value': 40},
        {'label': 'Sun', 'value': 92},
      ];
    }
    return const [
      {'label': 'May', 'value': 45},
      {'label': 'Jun', 'value': 72},
      {'label': 'Jul', 'value': 58},
      {'label': 'Aug', 'value': 89},
      {'label': 'Sep', 'value': 110},
      {'label': 'Oct', 'value': 135},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isLine = metadata.type == LobbyElementType.lineChart;
    final fallbackIcon = isLine ? Icons.show_chart_rounded : Icons.bar_chart_rounded;
    final iconData = IconResolver.resolve(metadata.icon, fallback: fallbackIcon);
    final accentColor = ColorResolver.resolve(metadata.colorToken, context, fallback: colors.primary);
    final points = _resolvePoints(isLine);

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    metadata.subtitle ?? (isLine ? '7-Day Trend' : '6 Months'),
                    style: GoogleFonts.inter(fontSize: 10, color: colors.onSurfaceMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                            colors: [
                              barColor,
                              barColor.withValues(alpha: 0.65),
                            ],
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

  Widget _buildLineChart(BuildContext context, AppPalette colors, Color lineColor, List<Map<String, dynamic>> points) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _SparklinePainter(
              points: points.map((p) => (p['value'] as num?)?.toDouble() ?? 0.0).toList(),
              color: lineColor,
            ),
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

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final maxVal = points.reduce(math.max);
    final minVal = points.reduce(math.min);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.35),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final stepX = size.width / (points.length - 1);
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final normalized = (points[i] - minVal) / range;
      final y = size.height - (normalized * (size.height - 14)) - 7;
      offsets.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final dotRingPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final last = offsets.last;
    canvas.drawCircle(last, 3.5, dotPaint);
    canvas.drawCircle(last, 3.5, dotRingPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
