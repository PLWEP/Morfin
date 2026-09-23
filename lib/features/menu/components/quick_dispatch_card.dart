import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../menu_contract.dart';

class QuickDispatchCard extends StatelessWidget {
  final QuickDispatchItem item;
  final VoidCallback? onTap;

  const QuickDispatchCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.surfaceBorder.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 20, color: colors.statusActive),
                ),
                if (item.badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: _badgeBgColor(item.badgeType, colors),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.badgeText!,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _badgeFgColor(item.badgeType, colors),
                      ),
                    ),
                  )
                else if (item.badgeType == ModuleBadgeType.active)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: colors.statusActive,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.statusActive,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                else if (item.badgeType == ModuleBadgeType.success)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: colors.statusSuccess,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _badgeBgColor(ModuleBadgeType type, AppPalette colors) {
    return switch (type) {
      ModuleBadgeType.warning => colors.statusWarning.withValues(alpha: 0.2),
      ModuleBadgeType.critical => colors.statusCritical.withValues(alpha: 0.2),
      ModuleBadgeType.success => colors.statusSuccess.withValues(alpha: 0.2),
      _ => colors.primaryContainer.withValues(alpha: 0.2),
    };
  }

  Color _badgeFgColor(ModuleBadgeType type, AppPalette colors) {
    return switch (type) {
      ModuleBadgeType.warning => colors.statusWarning,
      ModuleBadgeType.critical => colors.statusCritical,
      ModuleBadgeType.success => colors.statusSuccess,
      _ => colors.statusActive,
    };
  }
}
