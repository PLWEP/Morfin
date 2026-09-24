import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'settings_profile_avatar.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SettingsProfileAvatar(imageUrl: _avatarUrl),
            const SizedBox(width: 14),
            Expanded(child: _buildDetails(colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(AppPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Alex Vance',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Operations Manager',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
