import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'industrial_setting_tile.dart';

class SettingsSecuritySection extends StatelessWidget {
  final VoidCallback onChangePasswordTap;

  const SettingsSecuritySection({
    super.key,
    required this.onChangePasswordTap,
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
              Icon(Icons.security_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Text(
                'Security',
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
            icon: Icons.lock_reset_rounded,
            iconColor: colors.statusActive,
            title: 'Change Password',
            subtitle: 'Change your account password',
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colors.outline,
            ),
            onTap: onChangePasswordTap,
          ),
        ),
      ],
    );
  }
}
