import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsConnectivitySection extends StatelessWidget {
  final bool isOfflineMode;
  final String syncChannel;
  final ValueChanged<bool> onOfflineModeChanged;
  final VoidCallback? onSwitchServer;

  const SettingsConnectivitySection({
    super.key,
    required this.isOfflineMode,
    required this.syncChannel,
    required this.onOfflineModeChanged,
    this.onSwitchServer,
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
                    'SERVER & CONNECTIVITY',
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
                icon: Icons.dns_rounded,
                title: 'IFS Cloud Prod Cluster',
                titleSuffix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ap-southeast-1',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      color: colors.statusActive,
                    ),
                  ),
                ),
                subtitle: 'Latency: 24ms (TLS 1.3)',
                trailing: InkWell(
                  onTap: onSwitchServer,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Switch',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.statusActive,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 14,
                          color: colors.statusActive,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
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
