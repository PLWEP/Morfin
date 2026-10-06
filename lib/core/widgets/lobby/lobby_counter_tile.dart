import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';
import 'lobby_detail_sheet.dart';

class LobbyCounterTile extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyCounterTile({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iconData = IconResolver.resolve(metadata.icon, fallback: Icons.assignment_outlined);
    final accentColor = ColorResolver.resolve(metadata.colorToken, context, fallback: colors.statusWarning);

    return InkWell(
      onTap: () => LobbyDetailSheet.show(context, metadata),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 126),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    metadata.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(iconData, size: 14, color: accentColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  metadata.value ?? '0',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                    letterSpacing: -0.6,
                  ),
                ),
                if (metadata.unit != null && metadata.unit!.isNotEmpty) ...[
                  const SizedBox(width: 5),
                  Text(
                    metadata.unit!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: (metadata.isPositive ? colors.statusSuccess : colors.statusCritical)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        metadata.isPositive ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        size: 11,
                        color: metadata.isPositive ? colors.statusSuccess : colors.statusCritical,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        metadata.change ?? 'Live metrics',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: metadata.isPositive ? colors.statusSuccess : colors.statusCritical,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
