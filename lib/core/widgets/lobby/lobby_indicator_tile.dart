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
    final iconData = IconResolver.resolve(metadata.icon, fallback: Icons.speed_rounded);
    final pct = (metadata.percentage ?? 0).clamp(0.0, 100.0);
    final target = (metadata.target ?? 100.0).clamp(0.0, 100.0);
    final isPassing = pct >= target;

    final barColor = ColorResolver.resolve(
      metadata.colorToken,
      context,
      fallback: isPassing ? colors.statusSuccess : colors.statusWarning,
    );

    return InkWell(
      onTap: () => AppActionDispatcher.dispatch(context, metadata.action, fallbackTitle: metadata.title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(iconData, size: 16, color: barColor),
                    const SizedBox(width: 8),
                    Text(
                      metadata.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${pct.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (pct / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (metadata.subtitle != null)
                  Text(
                    metadata.subtitle!,
                    style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant),
                  )
                else
                  const SizedBox.shrink(),
                Text(
                  'Target: ${target.toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
