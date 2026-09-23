import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class SettingsTerminalLockCard extends StatelessWidget {
  final VoidCallback? onLockTerminal;

  const SettingsTerminalLockCard({super.key, this.onLockTerminal});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        // Danger Button: Lock Terminal
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onLockTerminal,
            icon: Icon(
              Icons.lock_person_rounded,
              size: 20,
              color: colors.statusCritical,
            ),
            label: Text(
              'Log Out',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.statusCritical,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.statusCritical.withValues(alpha: 0.08),
              side: BorderSide(
                color: colors.statusCritical.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
