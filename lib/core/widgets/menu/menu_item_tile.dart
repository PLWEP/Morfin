import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/menu_metadata.dart';
import '../../navigation/action_dispatcher.dart';
import '../../utils/icon_resolver.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItemMetadata item;
  final VoidCallback? onTap;

  const MenuItemTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iconData = IconResolver.resolve(item.icon, fallback: Icons.folder_outlined);
    final (badgeBg, badgeFg) = _resolveBadgeColors(item.badgeType, colors);

    return InkWell(
      onTap: onTap ??
          () => AppActionDispatcher.dispatch(context, item.action, fallbackTitle: item.title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.surfaceBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: badgeFg, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.code,
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: colors.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (item.badgeText != null && item.badgeText!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.badgeText!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 18, color: colors.outlineVariant),
          ],
        ),
      ),
    );
  }

  (Color, Color) _resolveBadgeColors(String type, AppPalette colors) {
    switch (type.toLowerCase()) {
      case 'active':
      case 'info':
        return (colors.statusActive.withValues(alpha: 0.12), colors.statusActive);
      case 'warning':
        return (colors.statusWarning.withValues(alpha: 0.12), colors.statusWarning);
      case 'critical':
      case 'error':
        return (colors.statusCritical.withValues(alpha: 0.12), colors.statusCritical);
      case 'success':
        return (colors.statusSuccess.withValues(alpha: 0.12), colors.statusSuccess);
      case 'hardware':
      case 'primary':
        return (colors.primary.withValues(alpha: 0.12), colors.primary);
      default:
        return (colors.surfaceContainerHigh, colors.outline);
    }
  }
}
