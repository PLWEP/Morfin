import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyKpiDrilldownSheet extends StatelessWidget {
  final AnalyticalKpi kpi;

  const LobbyKpiDrilldownSheet({super.key, required this.kpi});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final hourlyData = [
      ('08:00 - 10:00', '92.4%', 'Above benchmark'),
      ('10:00 - 12:00', '94.8%', 'Peak efficiency'),
      ('12:00 - 14:00', '91.0%', 'Minor lunch shift delay'),
      ('14:00 - 16:00', '95.2%', 'Target pace sustained'),
      ('16:00 - 18:00', '94.2%', 'Optimal output'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: colors.surfaceBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(kpi.icon, size: 20, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(kpi.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 20, color: colors.onSurfaceVariant),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Value', style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(kpi.value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: colors.onSurface)),
                        if (kpi.unit.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Text(kpi.unit, style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(kpi.benchmark, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.statusSuccess.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${kpi.change} vs prior',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.statusSuccess),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Hourly Breakdown', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface)),
          const SizedBox(height: 8),
          ...hourlyData.map((row) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row.$1, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurface)),
                  Row(
                    children: [
                      Text(row.$2, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primary)),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: colors.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Text(row.$3, style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
