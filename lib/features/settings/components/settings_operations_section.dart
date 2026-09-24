import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsOperationsSection extends StatelessWidget {
  final bool isEscalationAlerts;
  final ValueChanged<bool> onEscalationAlertsChanged;

  const SettingsOperationsSection({
    super.key,
    required this.isEscalationAlerts,
    required this.onEscalationAlertsChanged,
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
              Icon(
                Icons.notifications_active_rounded,
                size: 16,
                color: colors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Notifications',
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
            icon: Icons.notifications_active_rounded,
            iconColor: colors.statusWarning,
            title: 'Push Notifications',
            subtitle: 'Receive alerts for updates and tasks',
            trailing: Switch(
              value: isEscalationAlerts,
              activeThumbColor: colors.statusActive,
              onChanged: onEscalationAlertsChanged,
            ),
          ),
        ),
      ],
    );
  }
}
