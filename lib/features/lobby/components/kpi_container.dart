import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class KpiContainer extends StatelessWidget {
  final String headerTitle;
  final IconData headerIcon;
  final Color headerIconColor;
  final Widget content;
  final Widget bottomStrip;

  const KpiContainer({
    super.key,
    required this.headerTitle,
    required this.headerIcon,
    required this.headerIconColor,
    required this.content,
    required this.bottomStrip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
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
                headerTitle,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(headerIcon, size: 16, color: headerIconColor),
            ],
          ),
          content,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.surfaceBorder.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: bottomStrip,
          ),
        ],
      ),
    );
  }
}
