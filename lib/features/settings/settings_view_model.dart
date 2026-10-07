import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/industrial_feedback_service.dart';
import '../../core/storage/local_storage_service.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/services/cache_manager_service.dart';
import '../../core/services/navigator_service.dart';
import 'settings_contract.dart';

class SettingsViewModel extends ValueNotifier<SettingsState> {
  final CacheManagerService _cacheManager;

  SettingsViewModel({CacheManagerService? cacheManager})
      : _cacheManager = cacheManager ?? CacheManagerService.instance,
        super(const SettingsState()) {
    _loadPreferences();
    refreshCacheSize();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);
    final ind = storage.getIndustrialMode();
    final snd = storage.getSoundFeedback();
    IndustrialFeedbackService.instance.isSoundEnabled = snd;
    value = value.copyWith(isIndustrialMode: ind, isSoundEnabled: snd);
  }

  Future<void> refreshCacheSize() async {
    final text = await _cacheManager.getCacheSizeDescription();
    value = value.copyWith(cacheSizeText: text);
  }

  void dispatch(SettingsAction action) async {
    switch (action) {
      case SettingsClearCache():
        await _cacheManager.clearCache();
        NavigatorService.instance.clearCache();
        final text = await _cacheManager.getCacheSizeDescription();
        value = value.copyWith(
          cacheSizeText: text,
          toastMessage: 'Cache cleared successfully',
        );
      case SettingsExportLogs():
        value = value.copyWith(
          toastMessage: 'Logs export initiated',
        );
      case SettingsLockTerminal():
        ApiClient.instance.logout();
        NavigatorService.instance.clearCache();
        value = value.copyWith(
          toastMessage: 'Logged out successfully',
        );
      case SettingsToggleIndustrialMode(enabled: final enabled):
        final prefs = await SharedPreferences.getInstance();
        await LocalStorageService(prefs).saveIndustrialMode(enabled);
        value = value.copyWith(
          isIndustrialMode: enabled,
          toastMessage: enabled ? 'Industrial Terminal Mode Enabled' : 'Standard Mode Enabled',
        );
      case SettingsToggleSoundFeedback(enabled: final enabled):
        final prefs = await SharedPreferences.getInstance();
        await LocalStorageService(prefs).saveSoundFeedback(enabled);
        IndustrialFeedbackService.instance.isSoundEnabled = enabled;
        value = value.copyWith(
          isSoundEnabled: enabled,
          toastMessage: enabled ? 'Sound Feedback Enabled' : 'Sound Muted',
        );
      case SettingsDismissToast():
        value = value.copyWith(clearToast: true);
    }
  }
}
