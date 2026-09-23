import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsHardwareStorageSection extends StatelessWidget {
  final String cacheSizeText;
  final VoidCallback? onClearCache;
  final VoidCallback? onExportLogs;

  const SettingsHardwareStorageSection({
    super.key,
    required this.cacheSizeText,
    this.onClearCache,
    this.onExportLogs,
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
                  Icon(Icons.memory_rounded, size: 16, color: colors.statusActive),
                  const SizedBox(width: 6),
                  Text(
                    'SYSTEM & RUGGED HARDWARE',
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
                'PORT: COM-02',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.outline,
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
                icon: Icons.qr_code_scanner_rounded,
                iconColor: colors.statusActive,
                title: 'Barcode & RFID Hardware',
                titleSuffix: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colors.statusSuccess,
                    shape: BoxShape.circle,
                  ),
                ),
                subtitle: 'Built-in Camera & Bluetooth Zebra Scanner',
                trailing: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bluetooth_connected_rounded,
                    size: 18,
                    color: colors.statusActive,
                  ),
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.folder_shared_rounded,
                iconColor: colors.primary,
                title: 'Cache Storage & Work Orders',
                subtitle: cacheSizeText,
                trailing: InkWell(
                  onTap: onClearCache,
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
                        Icon(
                          Icons.cleaning_services_rounded,
                          size: 14,
                          color: colors.statusWarning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Clear',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.statusWarning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.assignment_rounded,
                iconColor: colors.onSurfaceVariant,
                title: 'Diagnostic Logs & Telemetry',
                subtitle: 'Full cryptographic runtime journal',
                trailing: InkWell(
                  onTap: onExportLogs,
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
                        Icon(
                          Icons.file_download_rounded,
                          size: 14,
                          color: colors.statusActive,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Export',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
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
