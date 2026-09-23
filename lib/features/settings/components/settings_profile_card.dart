import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'settings_profile_avatar.dart';
import 'settings_profile_verification_bar.dart';

class SettingsProfileCard extends StatelessWidget {
  final VoidCallback? onQuickVerifyTap;

  const SettingsProfileCard({super.key, this.onQuickVerifyTap});

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDTqF9zKpoaA3XGEBT8aJBGarxPsl8BgSzCITflfjVNwmDJW904Q3mHHxKok3bgcaVweA-SGywOLrGHzMHbRxA3Sa0SUue4fYOf7Frb9F_oaOf5AT-wjXcMOEPGBxgngSK6J_cx7cAvY3cMPhJF8CVpxT6ClTGEOJGkPoBGckopCtRxl7-Eu4BMTqmDxFxTWsdBi4Y-AyUHCm83-XZgf5jvi3TR2BQsCx-dmQNn5wM3xpP_xGQHl5B7Cg';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
        gradient: LinearGradient(
          colors: [
            colors.primaryContainer.withValues(alpha: 0.12),
            colors.surfaceCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsProfileAvatar(imageUrl: _avatarUrl),
                const SizedBox(width: 12),
                Expanded(child: _buildDetails(colors)),
              ],
            ),
          ),
          SettingsProfileVerificationBar(
            onQuickVerifyTap: onQuickVerifyTap,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(AppPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SEC-04 COMMAND',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.statusActive,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              '#IFS-9048',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Commander Alex Vance',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          'Operations Director • Industrial Sector 4',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: colors.statusActive.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.statusActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Online • US-EAST-01',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: colors.statusActive,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_rounded,
                    size: 11,
                    color: colors.statusWarning,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'ZERO TRUST L4',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
