import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'kpi_container.dart';

class KpiApprovalsCard extends StatelessWidget {
  const KpiApprovalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return KpiContainer(
      headerTitle: 'APPROVALS',
      headerIcon: Icons.fact_check_outlined,
      headerIconColor: colors.statusWarning,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '7',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Orders',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.statusWarning,
                ),
              ),
            ],
          ),
          Text(
            r'$142.5K Pending',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      bottomStrip: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 13, color: colors.statusWarning),
              const SizedBox(width: 4),
              Text(
                '2 High Priority',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: colors.statusWarning,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_rounded,
              size: 13, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
