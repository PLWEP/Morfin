import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/lobby_metadata.dart';
import '../../navigation/action_dispatcher.dart';
import '../../utils/color_resolver.dart';
import '../../utils/icon_resolver.dart';

class LobbyIndicatorTile extends StatelessWidget {
  final LobbyElementMetadata metadata;

  const LobbyIndicatorTile({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iconData = IconResolver.resolve(metadata.icon, fallback: Icons.pie_chart_outline_rounded);
    
    final rawPct = metadata.percentage ?? 0.0;
    final pct = rawPct.clamp(0.0, 100.0);
    final target = (metadata.target ?? 100.0).clamp(0.0, 100.0);
    final isPassing = pct >= (target * 0.9);

    final barColor = ColorResolver.resolve(
      metadata.colorToken,
      context,
      fallback: isPassing ? colors.statusSuccess : colors.statusWarning,
    );

    return InkWell(
      onTap: () => AppActionDispatcher.dispatch(context, metadata.action, fallbackTitle: metadata.title),
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
                    color: barColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(iconData, size: 14, color: barColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${pct.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isPassing ? 'On Track' : 'Needs Review',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (pct / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Target: ${target.toInt()}%',
                  style: GoogleFonts.inter(fontSize: 10, color: colors.onSurfaceMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
