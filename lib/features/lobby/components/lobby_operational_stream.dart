import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyOperationalStream extends StatelessWidget {
  final List<OperationalFeed> feeds;

  const LobbyOperationalStream({super.key, required this.feeds});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRIORITY OPERATIONAL STREAM',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'LIVE // PRIO-1',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: feeds.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final feed = feeds[i];
            final badgeColor = _resolveColor(colors, feed.badgeType);
            final urgencyColor = _resolveColor(colors, feed.urgencyType);

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: colors.isDark
                        ? Colors.black.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              feed.badgeTag,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: badgeColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            feed.itemId,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(feed.urgencyIcon, size: 14, color: urgencyColor),
                          const SizedBox(width: 4),
                          Text(
                            feed.urgencyText,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: urgencyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feed.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feed.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.surfaceBorder.withValues(alpha: 0.6)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(feed.footerIcon, size: 14, color: colors.onSurfaceMuted),
                        const SizedBox(width: 6),
                        Text(
                          feed.footerMeta,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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
