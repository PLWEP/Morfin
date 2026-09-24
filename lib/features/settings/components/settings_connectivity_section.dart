import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsConnectivitySection extends StatelessWidget {
  final bool isOfflineMode;
  final String syncChannel;
  final ValueChanged<bool> onOfflineModeChanged;

  const SettingsConnectivitySection({
    super.key,
    required this.isOfflineMode,
    required this.syncChannel,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
              Text(
                '100% OPERATIONAL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.statusSuccess,
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
          child: Column(
            children: [
              IndustrialSettingTile(
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
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.bolt_rounded,
                iconColor: colors.statusActive,
                title: 'Data Sync Channel',
                subtitle: 'Telemetry stream via WebSocket heartbeat',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        syncChannel,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.statusActive,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.expand_more_rounded,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
