import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsConnectivitySection extends StatelessWidget {
  final bool isOfflineMode;
  final ValueChanged<bool> onOfflineModeChanged;

  const SettingsConnectivitySection({
    super.key,
    required this.isOfflineMode,
    required this.onOfflineModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.hub_rounded, size: 16, color: colors.statusActive),
              const SizedBox(width: 6),
              Text(
                'CONNECTIVITY & NETWORK',
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
            icon: Icons.cloud_sync_rounded,
            iconColor: colors.primary,
            title: 'Offline Mode & Cache',
            subtitle: 'Auto-sync queue when connection restores',
            trailing: Switch(
              value: isOfflineMode,
              activeThumbColor: colors.statusActive,
              onChanged: onOfflineModeChanged,
            ),
          ),
        ),
      ],
    );
  }
}
