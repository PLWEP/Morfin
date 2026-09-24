import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class NotificationsHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  const NotificationsHeader({
    super.key,
    required this.unreadCount,
    this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unreadCount > 0
                  ? '$unreadCount unread notification${unreadCount > 1 ? "s" : ""}'
                  : 'All notifications caught up',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: colors.outline,
              ),
            ),
          ],
        ),
        if (unreadCount > 0)
          TextButton.icon(
            onPressed: onMarkAllRead,
            icon: Icon(
              Icons.done_all_rounded,
              size: 16,
              color: colors.primary,
            ),
            label: Text(
              'Mark all read',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              backgroundColor: colors.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
