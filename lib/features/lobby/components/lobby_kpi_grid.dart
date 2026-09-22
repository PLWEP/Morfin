import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/sparkline_painter.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyKpiGrid extends StatelessWidget {
  final List<KpiItem> kpis;

  const LobbyKpiGrid({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final item = kpis[index];
        return _buildKpiCard(context, item);
      },
    );
  }

  Widget _buildKpiCard(BuildContext context, KpiItem item) {
    final colors = AppColors.of(context);
    final statusColor = _resolveColor(colors, item.statusType);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              if (item.badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.badgeText!,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                )
              else if (item.badgeDotType != null)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        item.mainValue,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                      if (item.mainUnit.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          item.mainUnit,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    item.subValue,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              if (item.sparklineData != null)
                SizedBox(
                  width: 48,
                  height: 24,
                  child: CustomPaint(
                    painter: SparklinePainter(
                      data: item.sparklineData!,
                      lineColor: statusColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Icon(item.bottomIcon, size: 12, color: colors.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.bottomText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _resolveColor(AppPalette colors, String type) {
    switch (type) {
      case 'warning':
        return colors.statusWarning;
      case 'active':
        return colors.statusActive;
      case 'success':
        return colors.statusSuccess;
      case 'critical':
        return colors.statusCritical;
      default:
        return colors.primary;
    }
  }
}
