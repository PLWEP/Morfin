import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isUnread = !item.isRead;

    return Container(
      decoration: BoxDecoration(
        color: isUnread
            ? colors.surfaceContainer
            : colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? colors.primary.withValues(alpha: 0.3)
              : colors.surfaceBorder,
          width: isUnread ? 1.2 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUnread
                        ? colors.primary.withValues(alpha: 0.15)
                        : colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon ?? Icons.notifications_none_rounded,
                    size: 20,
                    color: isUnread ? colors.primary : colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isUnread
                              ? colors.onSurfaceVariant
                              : colors.outline,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.time,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: colors.outline,
                            ),
                          ),
                          Text(
                            isUnread ? 'Unread' : 'Read',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isUnread
                                  ? colors.primary
                                  : colors.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
