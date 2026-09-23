import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';

class ApprovalRequestCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ApprovalRequestCard({
    super.key,
    required this.item,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: colors.statusWarning),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(colors),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.price ?? r'$18,400.00',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.statusWarning,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'USD • Cost Center CC-8902',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: colors.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppPalette colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.statusWarning.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long_rounded, size: 11, color: colors.statusWarning),
                  const SizedBox(width: 4),
                  Text(
                    item.tag,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.statusWarning,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(item.timeAgo, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: colors.outline)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Action Req.',
            style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w600, color: colors.statusWarning),
          ),
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
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600, color: fgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
