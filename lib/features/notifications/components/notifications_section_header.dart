import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class NotificationsSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final Color badgeColor;

  const NotificationsSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Text(
          badgeText,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: badgeColor,
          ),
        ),
      ],
    );
  }
}
