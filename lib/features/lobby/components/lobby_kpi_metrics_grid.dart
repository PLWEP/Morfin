import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyKpiMetricsGrid extends StatelessWidget {
  final List<AnalyticalKpi> kpis;

  const LobbyKpiMetricsGrid({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 130,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return _buildKpiCard(context, kpis[index]);
      },
    );
  }

  Widget _buildKpiCard(BuildContext context, AnalyticalKpi kpi) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kpi.title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.outline,
                ),
              ),
              Icon(kpi.icon, size: 16, color: colors.statusActive),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                kpi.value,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              if (kpi.unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  kpi.unit,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colors.outline,
                  ),
                ),
              ],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.statusSuccess.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  kpi.change,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.statusSuccess,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  kpi.benchmark,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: colors.outline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
