import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/login_form_card.dart';
import 'login_contract.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final state = _viewModel.value;
    if (state.notificationMessage != null && mounted) {
      final colors = AppColors.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.surfaceCard,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: colors.statusActive, width: 1),
          ),
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: colors.statusActive, size: 18),
              const SizedBox(width: 8),
              Text(
                state.notificationMessage!,
                style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
              ),
            ],
          ),
        ),
      );
      _viewModel.dispatch(const LoginConsumeNotificationAction());
    }

    if (state.isSuccess && mounted) {
      Navigator.of(context).pushReplacementNamed('/lobby');
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Card
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.surfaceBorder,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.isDark
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida/AEtjO1XE5IqVYas3jIWiElWM7qe6FsSCZV0quXLVZleMrKIMfp7o4ZoKRFpfUxwqXMy90nY7BJvpt3ISnv93YVBV7IzUrUoPWNjYA1nLg3rla7ClDWV7Ocoul7IYxKfRN66_Pfpcm0NsAr3ahe1FG_H1VtiNYen3palwP4YfI0d5h8LYyPZWBUIhGeU1evCsl5mBVraUyZfOafgMlhh-8QZsLzcYBW6GcqTmUpjskomVfOPP1Lp_SLJZsVat8oTs',
                          width: 58,
                          height: 58,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => Icon(
                            Icons.hub_rounded,
                            size: 42,
                            color: colors.statusActive,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Titles
                  Text(
                    'IFS Cloud Mobile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enterprise Resource & Field Operations',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form Container Card
                  ValueListenableBuilder<LoginState>(
                    valueListenable: _viewModel,
                    builder: (context, state, _) {
                      return LoginFormCard(
                        state: state,
                        onAction: _viewModel.dispatch,
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Legal Footer
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
