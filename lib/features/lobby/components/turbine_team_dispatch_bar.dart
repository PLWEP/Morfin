import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class TurbineTeamDispatchBar extends StatelessWidget {
  final VoidCallback? onAuditTap;

  const TurbineTeamDispatchBar({
    super.key,
    this.onAuditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_rounded,
                size: 14,
                color: colors.statusActive,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Field Team 2 Dispatched (ETA 14m)',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onAuditTap ?? () {},
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  'Audit Details',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.statusActive,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: colors.statusActive,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
