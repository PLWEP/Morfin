import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class TurbineImageOverlay extends StatelessWidget {
  const TurbineImageOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDpCA5C7E3uONSG7uiBjgrwvkQ4jVH8KGg-LLHirXp6rsR8mCneML0sVT96Hx_dS_haiCAUFl0YzZhfTkzO_czHEStRLKa4thtMXXLaZ3-ubRZPjYHaJOhD6Zxe50vGu91sDUqyrdAWFPziFehJ8XbvVB23sy3T5EAH6bdIzztfK4U0S9SzQ0vIbRIRYeKg_BS1M2imp4jQTAVJo09c4_c8JqruKm8f0AyIc5CZY6o-f5eZ-OUHXANGIg',
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              height: 110,
              color: colors.surfaceContainer,
              alignment: Alignment.center,
              child: Icon(
                Icons.speed_rounded,
                size: 36,
                color: colors.statusCritical,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.statusWarning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Vibration: 7.8 mm/s RMS (Limit 4.5)',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Sector 02-B',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: colors.statusActive,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
