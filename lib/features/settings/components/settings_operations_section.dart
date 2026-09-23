import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsOperationsSection extends StatelessWidget {
  final bool isEscalationAlerts;
  final bool isBiometrics;
  final ValueChanged<bool> onEscalationAlertsChanged;
  final ValueChanged<bool> onBiometricsChanged;

  const SettingsOperationsSection({
    super.key,
    required this.isEscalationAlerts,
    required this.isBiometrics,
    required this.onEscalationAlertsChanged,
    required this.onBiometricsChanged,
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
                  Icon(Icons.tune_rounded, size: 16, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'PREFERENCES & FIELD OPERATIONS',
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
                'SITE CONFIG',
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
                icon: Icons.space_dashboard_rounded,
                iconColor: colors.statusWarning,
                title: 'Default Landing Node',
                subtitle: 'Workspace loaded on terminal spin-up',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Lobby Dashboard',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.unfold_more_rounded,
                        size: 14,
                        color: colors.outline,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.square_foot_rounded,
                iconColor: colors.statusActive,
                title: 'Industrial Unit System',
                subtitle: 'Asset sensor readouts and tolerances',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Metric (°C, bar, mm/s)',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusActive,
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.notifications_active_rounded,
                iconColor: colors.statusWarning,
                title: 'Shift Escalation Alerts',
                titleSuffix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: colors.statusWarning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Filter Active',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      color: colors.statusWarning,
                    ),
                  ),
                ),
                subtitle: 'Critical & High Priority Only',
                trailing: Switch(
                  value: isEscalationAlerts,
                  activeThumbColor: colors.statusActive,
                  onChanged: onEscalationAlertsChanged,
                ),
              ),
              Divider(height: 1, color: colors.surfaceBorder.withValues(alpha: 0.5)),
              IndustrialSettingTile(
                icon: Icons.fingerprint_rounded,
                iconColor: colors.statusSuccess,
                title: 'Biometric Security Gateway',
                subtitle: 'Face ID & PIN Enabled',
                trailing: Switch(
                  value: isBiometrics,
                  activeThumbColor: colors.statusSuccess,
                  onChanged: onBiometricsChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
