import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'kpi_container.dart';

class KpiWorkOrdersCard extends StatelessWidget {
  const KpiWorkOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return KpiContainer(
      headerTitle: 'Work Orders',
      headerIcon: Icons.build_circle_outlined,
      headerIconColor: colors.statusCritical,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '24',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: colors.statusCritical.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '4 Urgent',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.statusCritical,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '8 active • 12 queued',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      bottomStrip: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Avg completion: 42m',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colors.onSurfaceVariant,
            ),
          ),
          Icon(Icons.arrow_forward_rounded,
              size: 13, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
