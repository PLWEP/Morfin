import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PrBudgetDetails extends StatelessWidget {
  const PrBudgetDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vendor: Rexroth Bosch Ind.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Text(
                'Lead Time: 48h Expedited',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cost Center: CC-8902-HYD',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Text(
                'Budget Available',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.statusSuccess,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
