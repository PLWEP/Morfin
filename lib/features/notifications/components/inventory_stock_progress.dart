import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class InventoryStockProgress extends StatelessWidget {
  final double progress;
  final String? progressLabel;
  final String capacityLabel;

  const InventoryStockProgress({
    super.key,
    required this.progress,
    this.progressLabel,
    this.capacityLabel = 'Capacity: 60 Drums',
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: colors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation(colors.statusWarning),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              capacityLabel,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: colors.outline,
              ),
            ),
            Text(
              progressLabel ?? 'Remaining: 20%',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.statusWarning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
