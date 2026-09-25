import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import '../../core/services/cache_manager_service.dart';
import 'settings_contract.dart';

class SettingsViewModel extends ValueNotifier<SettingsState> {
  final CacheManagerService _cacheManager;

  SettingsViewModel({CacheManagerService? cacheManager})
      : _cacheManager = cacheManager ?? CacheManagerService.instance,
        super(const SettingsState()) {
    refreshCacheSize();
  }

  Future<void> refreshCacheSize() async {
    final text = await _cacheManager.getCacheSizeDescription();
    value = value.copyWith(cacheSizeText: text);
  }

  void dispatch(SettingsAction action) async {
    switch (action) {
      case SettingsClearCache():
        await _cacheManager.clearCache();
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
        value = value.copyWith(
          toastMessage: 'Logged out successfully',
        );
      case SettingsDismissToast():
        value = value.copyWith(clearToast: true);
    }
  }
}
