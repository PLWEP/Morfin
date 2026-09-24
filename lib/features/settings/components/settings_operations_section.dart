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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.notifications_active_rounded, size: 16, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'FIELD ALERTS & NOTIFICATIONS',
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
                'FILTER',
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
          child: IndustrialSettingTile(
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
        ),
      ],
    );
  }
}
