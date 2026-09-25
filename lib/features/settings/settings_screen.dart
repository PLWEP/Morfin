import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../theme/app_colors.dart';
import 'components/activity_logs_sheet.dart';
import 'components/settings_hardware_storage_section.dart';
import 'components/settings_profile_card.dart';
import 'components/settings_terminal_lock_card.dart';
import 'components/settings_theme_section.dart';
import 'settings_contract.dart';
import 'settings_view_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
                  style: GoogleFonts.inter(fontSize: 13),
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
                  SettingsHardwareStorageSection(
                    cacheSizeText: state.cacheSizeText,
                    onClearCache: () {
                      _viewModel.dispatch(const SettingsClearCache());
                    },
                    onExportLogs: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ActivityLogsSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingsTerminalLockCard(
                    onLockTerminal: () {
                      ref.read(userProfileProvider.notifier).clear();
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
