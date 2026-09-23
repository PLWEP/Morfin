import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class ApprovalCardActions extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ApprovalCardActions({
    super.key,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        _buildButton(
          onTap: onReject,
          bgColor: colors.surfaceContainerHigh,
          fgColor: colors.onSurface,
          iconColor: colors.statusCritical,
          icon: Icons.close_rounded,
          label: 'Reject',
        ),
        const SizedBox(width: 8),
        _buildButton(
          onTap: onApprove,
          bgColor: colors.primaryContainer,
          fgColor: colors.onPrimaryContainer,
          iconColor: colors.onPrimaryContainer,
          icon: Icons.check_circle_rounded,
          label: 'Approve Now',
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback? onTap,
    required Color bgColor,
    required Color fgColor,
    required Color iconColor,
    required IconData icon,
    required String label,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
