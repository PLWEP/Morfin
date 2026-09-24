import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyOeeBreakdownCard extends StatelessWidget {
  final List<OeeFactor> factors;

  const LobbyOeeBreakdownCard({super.key, required this.factors});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OEE Factor Breakdown',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              Icon(Icons.pie_chart_outline_rounded,
                  size: 18, color: colors.statusActive),
            ],
          ),
          const SizedBox(height: 14),
          ...factors.map((factor) => _buildFactorItem(colors, factor)),
        ],
      ),
    );
  }

  Widget _buildFactorItem(AppPalette colors, OeeFactor factor) {
    final pctString = '${(factor.percentage * 100).toStringAsFixed(1)}%';
    final isTargetMet = factor.percentage >= factor.target;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                factor.name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
              Row(
                children: [
                  Text(
                    pctString,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isTargetMet
                          ? colors.statusSuccess
                          : colors.statusWarning,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(Target: ${(factor.target * 100).toInt()}%)',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: colors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: factor.percentage,
              minHeight: 6,
              backgroundColor: colors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                isTargetMet ? colors.statusSuccess : colors.statusWarning,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            factor.details,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: colors.outline,
            ),
          ),
        ],
      ),
    );
  }
}
