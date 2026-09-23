import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class SettingsProfileVerificationBar extends StatelessWidget {
  final VoidCallback? onQuickVerifyTap;

  const SettingsProfileVerificationBar({
    super.key,
    this.onQuickVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(13)),
        border: Border(
          top: BorderSide(
            color: colors.surfaceBorder.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.sync_rounded,
                size: 14,
                color: colors.statusSuccess,
              ),
              const SizedBox(width: 6),
              Text(
                'Last Full Node Check: 42s ago',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: onQuickVerifyTap ?? () {},
            child: Row(
              children: [
                Text(
                  'Quick Verify',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.statusActive,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: colors.statusActive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
