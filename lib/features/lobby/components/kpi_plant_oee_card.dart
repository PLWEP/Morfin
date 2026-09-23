import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/sparkline_painter.dart';
import '../../../theme/app_colors.dart';
import 'kpi_container.dart';

class KpiPlantOeeCard extends StatelessWidget {
  const KpiPlantOeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return KpiContainer(
      headerTitle: 'PLANT OEE',
      headerIcon: Icons.speed_rounded,
      headerIconColor: colors.statusActive,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '94.2%',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.statusActive,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded,
                      size: 13, color: colors.statusSuccess),
                  const SizedBox(width: 3),
                  Text(
                    '+1.8% target',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusSuccess,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 48,
            height: 24,
            child: CustomPaint(
              painter: SparklinePainter(
                data: const [24, 18, 22, 10, 14, 4],
                lineColor: colors.statusActive,
              ),
            ),
          ),
        ],
      ),
      bottomStrip: Text(
        'Availability: 98.4%',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
