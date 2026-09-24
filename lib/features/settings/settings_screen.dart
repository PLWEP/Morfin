import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'change_password_screen.dart';
import 'components/settings_connectivity_section.dart';
import 'components/settings_hardware_storage_section.dart';
import 'components/settings_operations_section.dart';
import 'components/settings_profile_card.dart';
import 'components/settings_security_section.dart';
import 'components/settings_terminal_lock_card.dart';
import 'components/settings_theme_section.dart';
import 'settings_contract.dart';
import 'settings_view_model.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onAlertTap;

  const SettingsScreen({super.key, this.onAlertTap});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel();
    _viewModel.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final msg = _viewModel.value.toastMessage;
    if (msg != null && mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.of(context).statusActive, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  msg,
                  style: GoogleFonts.jetBrainsMono(fontSize: 11),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.of(context).surfaceBorder,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _viewModel.dispatch(const SettingsDismissToast());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<SettingsState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: colors.surfaceDeep,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingsProfileCard(),
                  const SizedBox(height: 18),
                  const SettingsThemeSection(),
                  const SizedBox(height: 18),
                  SettingsSecuritySection(
                    onChangePasswordTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChangePasswordScreen(
                            onReset: (newPassword) {
                              _viewModel.dispatch(SettingsChangePassword(newPassword));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  SettingsConnectivitySection(
                    isOfflineMode: state.isOfflineModeEnabled,
                    onOfflineModeChanged: (val) {
                      _viewModel.dispatch(SettingsToggleOfflineMode(val));
                    },
                  ),
                  const SizedBox(height: 18),
                  SettingsOperationsSection(
                    isEscalationAlerts: state.isEscalationAlertsEnabled,
                    onEscalationAlertsChanged: (val) {
                      _viewModel.dispatch(SettingsToggleEscalationAlerts(val));
                    },
                  ),
                  const SizedBox(height: 18),
                  SettingsHardwareStorageSection(
                    cacheSizeText: state.cacheSizeText,
                    onClearCache: () {
                      _viewModel.dispatch(const SettingsClearCache());
                    },
                    onExportLogs: () {
                      _viewModel.dispatch(const SettingsExportLogs());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingsTerminalLockCard(
                    onLockTerminal: () {
                      _viewModel.dispatch(const SettingsLockTerminal());
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
