import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/sleek_grid_painter.dart';
import 'components/splash_ambient_glow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(milliseconds: 3500), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: Stack(
        children: [
          // Sleek grid background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: SleekGridPainter(color: colors.statusActive),
            ),
          ),

          // Ambient glow
          const SplashAmbientGlow(),

          // Centered Logo & Activity Spinner
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // Logo in Card with Glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: colors.primaryContainer.withValues(alpha: 0.2),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primaryContainer.withValues(alpha: 0.4),
                              blurRadius: 36,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colors.surfaceBorder,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: colors.isDark ? 0.5 : 0.1,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida/AEtjO1XE5IqVYas3jIWiElWM7qe6FsSCZV0quXLVZleMrKIMfp7o4ZoKRFpfUxwqXMy90nY7BJvpt3ISnv93YVBV7IzUrUoPWNjYA1nLg3rla7ClDWV7Ocoul7IYxKfRN66_Pfpcm0NsAr3ahe1FG_H1VtiNYen3palwP4YfI0d5h8LYyPZWBUIhGeU1evCsl5mBVraUyZfOafgMlhh-8QZsLzcYBW6GcqTmUpjskomVfOPP1Lp_SLJZsVat8oTs',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) => Icon(
                                Icons.hub_rounded,
                                size: 52,
                                color: colors.statusActive,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // Material Symbol progress_activity spinner
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.statusActive,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Copyright & Version Footer
                  Text(
                    'IFS Cloud © 2025 IFS AB. All rights reserved.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors.outline.withValues(alpha: 0.8),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 24.2 (Build 8842)',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors.outline.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
