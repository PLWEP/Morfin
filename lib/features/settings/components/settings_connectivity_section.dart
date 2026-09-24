import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';
import 'settings_offline_diagnostics_card.dart';

class SettingsConnectivitySection extends StatelessWidget {
  final bool isOfflineMode;
  final ValueChanged<bool> onOfflineModeChanged;
  final VoidCallback? onSyncNow;

  const SettingsConnectivitySection({
    super.key,
    required this.isOfflineMode,
    required this.onOfflineModeChanged,
    this.onSyncNow,
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
                'Network & Sync',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
            title: 'Offline Mode',
            subtitle: 'Save data locally and sync when reconnected',
            trailing: Switch(
              value: isOfflineMode,
              activeThumbColor: colors.statusActive,
              onChanged: onOfflineModeChanged,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SettingsOfflineDiagnosticsCard(
          onSyncNow: onSyncNow,
        ),
      ],
    );
  }
}
