import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'splash_contract.dart';
import 'splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashViewModel _viewModel;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel();
    _viewModel.addListener(_onStateChanged);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.dispatch(const SplashStartTelemetryAction());
    });
  }

  void _onStateChanged() {
    if (_viewModel.value.isCompleted && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    _viewModel.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: Stack(
        children: [
          // Background Tech Glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
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
            bottom: MediaQuery.of(context).size.height * 0.25,
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

          // Main Center Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Brand Logo with Pulse Animation
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: colors.surfaceCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colors.surfaceBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.isDark
                                ? colors.primary.withValues(alpha: 0.35)
                                : Colors.black.withValues(alpha: 0.08),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida/AEtjO1XE5IqVYas3jIWiElWM7qe6FsSCZV0quXLVZleMrKIMfp7o4ZoKRFpfUxwqXMy90nY7BJvpt3ISnv93YVBV7IzUrUoPWNjYA1nLg3rla7ClDWV7Ocoul7IYxKfRN66_Pfpcm0NsAr3ahe1FG_H1VtiNYen3palwP4YfI0d5h8LYyPZWBUIhGeU1evCsl5mBVraUyZfOafgMlhh-8QZsLzcYBW6GcqTmUpjskomVfOPP1Lp_SLJZsVat8oTs',
                            width: 76,
                            height: 76,
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
                  ),
                  const SizedBox(height: 24),

                  // App Title
                  Text(
                    'IFS Cloud Mobile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enterprise Operations & Field Terminal',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Telemetry Status Container (Observed from ViewModel)
                  ValueListenableBuilder<SplashState>(
                    valueListenable: _viewModel,
                    builder: (context, state, _) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors.surfaceBorder,
                            width: 1,
                          ),
                          boxShadow: [
                            if (!colors.isDark)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.statusActive,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    state.statusText,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11,
                                      color: colors.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${(state.progress * 100).toInt()}%',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: colors.statusActive,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: state.progress,
                                minHeight: 4,
                                backgroundColor: colors.surfaceBorder,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.statusActive,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),

                  // Legal & Version Footer
                  Text(
                    'IFS Cloud © 2025 IFS AB. All rights reserved.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 24.2 (Build 8842)',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
