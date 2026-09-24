import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyThroughputChartCard extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;

  const LobbyThroughputChartCard({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Throughput Trend',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Production pace vs benchmark',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.outline,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegend(colors, colors.statusActive, 'Actual'),
                  const SizedBox(width: 10),
                  _buildLegend(colors, colors.outline, 'Target'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _ChartPainter(
                data: dataPoints,
                barColor: colors.primary,
                targetColor: colors.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dataPoints
                .map((p) => Text(
                      p.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.outline,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(AppPalette colors, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: colors.outline,
          ),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color barColor;
  final Color targetColor;

  _ChartPainter({
    required this.data,
    required this.barColor,
    required this.targetColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data
        .map((e) => e.actual > e.target ? e.actual : e.target)
        .reduce((a, b) => a > b ? a : b);
    final ceiling = maxVal * 1.15;

    final barWidth = size.width / (data.length * 2.2);
    final step = size.width / data.length;

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final targetPaint = Paint()
      ..color = targetColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final targetPath = Path();

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final x = (i * step) + (step / 2);

      // Draw bar for actual
      final barHeight = (point.actual / ceiling) * size.height;
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - (barWidth / 2), size.height - barHeight, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(barRect, barPaint);

      // Construct target line
      final targetY = size.height - ((point.target / ceiling) * size.height);
      if (i == 0) {
        targetPath.moveTo(x, targetY);
      } else {
        targetPath.lineTo(x, targetY);
      }
    }

    canvas.drawPath(targetPath, targetPaint);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => true;
}
