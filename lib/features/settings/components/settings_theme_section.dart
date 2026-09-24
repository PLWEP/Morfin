import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme_controller.dart';
import 'industrial_setting_tile.dart';

class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'APPEARANCE & THEME',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: IndustrialSettingTile(
                icon: isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                iconColor: isDark ? colors.statusActive : colors.statusWarning,
                title: 'Dark Theme',
                subtitle: isDark
                    ? 'High-contrast dark palette'
                    : 'Clean daylight palette',
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) {
                    ThemeController.instance.toggleTheme(val);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
