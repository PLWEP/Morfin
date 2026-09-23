import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/ifs_logo_badge.dart';
import '../../../theme/app_colors.dart';

class LobbyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String connectionNode;
  final int unreadAlertCount;
  final VoidCallback? onAlertTap;

  const LobbyAppBar({
    super.key,
    required this.connectionNode,
    required this.unreadAlertCount,
    this.onAlertTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppBar(
      backgroundColor: colors.surfaceDeep.withValues(alpha: 0.95),
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.surfaceBorder),
            ),
            child: const Center(
              child: IfsLogoBadge(size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'IFS CLOUD',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.statusActive,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    ' / ',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Operations',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.statusSuccess,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    connectionNode,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none_rounded, color: colors.onSurfaceVariant, size: 22),
              onPressed: onAlertTap ?? () {},
            ),
            if (unreadAlertCount > 0)
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.statusActive,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.statusActive,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceCard,
              border: Border.all(
                color: colors.statusActive.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 20,
              color: colors.statusActive,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: colors.surfaceBorder.withValues(alpha: 0.8),
          height: 1,
        ),
      ),
    );
  }
}
