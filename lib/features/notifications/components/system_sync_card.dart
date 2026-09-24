import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';

class SystemSyncCard extends StatelessWidget {
  final NotificationItem item;

  const SystemSyncCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.surfaceBorder.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_done_rounded,
                          size: 11,
                          color: colors.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.tag,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: colors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.timeAgo,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: colors.outline,
                    ),
                  ),
                ],
              ),
              Text(
                'Verified',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colors.outline,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Size: 248.6 MB • Verified',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.outline,
                ),
              ),
              Icon(
                Icons.verified_user_rounded,
                size: 16,
                color: colors.statusSuccess,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
