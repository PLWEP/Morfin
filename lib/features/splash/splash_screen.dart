import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/splash_ambient_glow.dart';
import 'components/splash_telemetry_box.dart';
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
          const SplashAmbientGlow(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
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
                  ValueListenableBuilder<SplashState>(
                    valueListenable: _viewModel,
                    builder: (context, state, _) {
                      return SplashTelemetryBox(state: state);
                    },
                  ),
                  const Spacer(flex: 1),
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
