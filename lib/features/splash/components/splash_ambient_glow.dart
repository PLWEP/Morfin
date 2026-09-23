import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SplashAmbientGlow extends StatelessWidget {
  const SplashAmbientGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: height * 0.2,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: colors.isDark ? 0.12 : 0.08),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: colors.isDark ? 0.25 : 0.15),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: height * 0.25,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.statusActive.withValues(alpha: colors.isDark ? 0.08 : 0.05),
                boxShadow: [
                  BoxShadow(
                    color: colors.statusActive.withValues(alpha: colors.isDark ? 0.15 : 0.10),
                    blurRadius: 90,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
