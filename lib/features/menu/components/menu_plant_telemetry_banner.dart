import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class MenuPlantTelemetryBanner extends StatelessWidget {
  const MenuPlantTelemetryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
        gradient: LinearGradient(
          colors: [
            colors.surfaceCard,
            colors.surfaceContainerLow,
            colors.surfaceCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.statusActive.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                Icons.autorenew_rounded,
                color: colors.statusActive,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Facility 04',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.statusActive,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: colors.statusSuccess.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Connected',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.statusSuccess,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Complex B • Turbine Array #3',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '32 Active Sensors • Normal Status',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Mini equalizer graph
          SizedBox(
            height: 32,
            width: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _EqualizerBar(heightFactor: 0.40, color: colors.statusActive),
                _EqualizerBar(heightFactor: 0.75, color: colors.statusActive),
                _EqualizerBar(heightFactor: 0.60, color: colors.statusActive),
                _EqualizerBar(heightFactor: 0.90, color: colors.statusActive),
                _EqualizerBar(heightFactor: 0.65, color: colors.statusActive),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EqualizerBar extends StatelessWidget {
  final double heightFactor;
  final Color color;

  const _EqualizerBar({required this.heightFactor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 32 * heightFactor,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}
