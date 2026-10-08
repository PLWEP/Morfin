import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/services/industrial_feedback_service.dart';
import 'package:morfin/features/settings/settings_contract.dart';
import 'package:morfin/features/settings/settings_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsViewModel Unit Tests', () {
    late SettingsViewModel vm;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      vm = SettingsViewModel();
    });

    tearDown(() {
      vm.dispose();
    });

    test('initial state and preference toggles', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(vm.value.isIndustrialMode, false);
      expect(vm.value.isSoundEnabled, true);

      // Industrial mode toggle
      vm.dispatch(const SettingsToggleIndustrialMode(true));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(vm.value.isIndustrialMode, true);
      expect(vm.value.toastMessage, 'Industrial Terminal Mode Enabled');

      // Sound feedback toggle
      vm.dispatch(const SettingsToggleSoundFeedback(false));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(vm.value.isSoundEnabled, false);
      expect(IndustrialFeedbackService.instance.isSoundEnabled, false);
      expect(vm.value.toastMessage, 'Sound Muted');

      // Dismiss toast
      vm.dispatch(const SettingsDismissToast());
      expect(vm.value.toastMessage, isNull);
    });

    test('cache clear, export logs, and lock terminal actions', () async {
      vm.dispatch(const SettingsClearCache());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(vm.value.toastMessage, 'Cache cleared successfully');

      vm.dispatch(const SettingsExportLogs());
      expect(vm.value.toastMessage, 'Logs export initiated');

      vm.dispatch(const SettingsLockTerminal());
      expect(vm.value.toastMessage, 'Logged out successfully');
    });
  });
}
