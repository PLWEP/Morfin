import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class LobbyTacticalActions extends StatelessWidget {
  final ValueChanged<String> onActionTriggered;

  const LobbyTacticalActions({super.key, required this.onActionTriggered});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Terminal Dispatch',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '3 Modules Ready',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: colors.statusActive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // 1. Scan QR
            Expanded(
              child: _buildActionButton(
                context,
                id: 'scan_qr',
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan QR',
                isPrimary: false,
                iconColor: colors.statusActive,
              ),
            ),
            const SizedBox(width: 10),
            // 2. Create WO (Primary Action)
            Expanded(
              child: _buildActionButton(
                context,
                id: 'create_wo',
                icon: Icons.add_task_rounded,
                label: 'Create WO',
                isPrimary: true,
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            // 3. Dispatch
            Expanded(
              child: _buildActionButton(
                context,
                id: 'dispatch',
                icon: Icons.swap_horiz_rounded,
                label: 'Dispatch',
                isPrimary: false,
                iconColor: colors.statusWarning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String label,
    required bool isPrimary,
    required Color iconColor,
  }) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: () => onActionTriggered(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? colors.primary : colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: colors.surfaceBorder),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withValues(alpha: 0.15)
                    : colors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                color: isPrimary ? Colors.white : colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
