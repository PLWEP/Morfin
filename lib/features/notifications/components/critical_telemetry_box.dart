import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'sparkline_painter.dart';

class CriticalTelemetryBox extends StatelessWidget {
  final String sensorId;

  const CriticalTelemetryBox({
    super.key,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.device_thermostat_rounded, size: 16, color: colors.statusCritical),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TELEMETRY SENSOR',
                    style: GoogleFonts.jetBrainsMono(fontSize: 8, color: colors.outline),
                  ),
                  Text(
                    sensorId,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusCritical,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomPaint(
            size: const Size(60, 20),
            painter: SparklinePainter(color: colors.statusCritical),
          ),
        ],
      ),
    );
  }
}
