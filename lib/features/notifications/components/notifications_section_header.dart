import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class NotificationsSectionHeader extends StatelessWidget {
  final String title;
  final int? count;

  const NotificationsSectionHeader({
    super.key,
    required this.title,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colors.outline,
              ),
            ),
        ],
      ),
    );
  }
}
