import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'kpi_container.dart';

class KpiStockAlertsCard extends StatelessWidget {
  const KpiStockAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return KpiContainer(
      headerTitle: 'STOCK ALERTS',
      headerIcon: Icons.inventory_2_outlined,
      headerIconColor: colors.statusWarning,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '3',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Low Stock',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.statusWarning,
                ),
              ),
            ],
          ),
          Text(
            '1 SKU Depleted',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: colors.statusCritical,
            ),
          ),
        ],
      ),
      bottomStrip: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bin 4B-10, 8C-02',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: colors.onSurfaceVariant,
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            size: 13,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
