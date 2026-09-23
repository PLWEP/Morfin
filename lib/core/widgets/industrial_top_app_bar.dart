import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class IndustrialTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String connectionNode;
  final int unreadAlertCount;
  final VoidCallback? onAlertTap;
  final VoidCallback? onProfileTap;

  const IndustrialTopAppBar({
    super.key,
    required this.title,
    this.connectionNode = 'US-EAST-01 • 24ms',
    this.unreadAlertCount = 1,
    this.onAlertTap,
    this.onProfileTap,
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
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida/AEtjO1XE5IqVYas3jIWiElWM7qe6FsSCZV0quXLVZleMrKIMfp7o4ZoKRFpfUxwqXMy90nY7BJvpt3ISnv93YVBV7IzUrUoPWNjYA1nLg3rla7ClDWV7Ocoul7IYxKfRN66_Pfpcm0NsAr3ahe1FG_H1VtiNYen3palwP4YfI0d5h8LYyPZWBUIhGeU1evCsl5mBVraUyZfOafgMlhh-8QZsLzcYBW6GcqTmUpjskomVfOPP1Lp_SLJZsVat8oTs',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => Icon(
                    Icons.hub_rounded,
                    size: 18,
                    color: colors.statusActive,
                  ),
                ),
              ),
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
                    title,
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
              icon: Icon(
                Icons.notifications_none_rounded,
                color: colors.onSurfaceVariant,
                size: 22,
              ),
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
          child: InkWell(
            onTap: onProfileTap ?? () {},
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.statusActive.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida/AEtjO1VDYEQItSmUU2UWMZdC0owoXvE2iF4WvVU8NnGHAtEAUOp2lgzWlgW1aBP7HCTiVPSbWvIQG8dy6AQsTY2IDMFzLflU89SWvIN_fBcQPNruFCAfkmsJ33ijpfm2Pkd8ucUE-4DBRK6kAhDLN98plzlySbysVq5nVm-ojWzjuYVMx9gPWrMKI7b8ALW9ucFwxghkV3i58J0XH_nf7g_WZJs8AhMBBSM8Y15LqRl2Zs-3hdmHaY1ftuKdnLt0',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Icon(
                    Icons.person_rounded,
                    size: 20,
                    color: colors.statusActive,
                  ),
                ),
              ),
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
