import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import 'settings_contract.dart';

class SettingsViewModel extends ValueNotifier<SettingsState> {
  SettingsViewModel() : super(const SettingsState());

  void dispatch(SettingsAction action) {
    switch (action) {
      case SettingsToggleOfflineMode(value: final val):
        value = value.copyWith(
          isOfflineModeEnabled: val,
          toastMessage: 'Offline Mode: ${val ? "Enabled" : "Disabled"}',
        );
      case SettingsToggleEscalationAlerts(value: final val):
        value = value.copyWith(
          isEscalationAlertsEnabled: val,
          toastMessage: 'Notifications: ${val ? "Enabled" : "Disabled"}',
        );
      case SettingsClearCache():
        value = value.copyWith(
          cacheSizeText: '0 MB used • Cache cleared',
          toastMessage: 'Cache cleared successfully',
        );
      case SettingsExportLogs():
        value = value.copyWith(
          toastMessage: 'Logs exported successfully',
        );
      case SettingsLockTerminal():
        ApiClient.instance.logout();
        value = value.copyWith(
          toastMessage: 'Logged out successfully',
        );
      case SettingsChangePassword():
        value = value.copyWith(
          toastMessage: 'Password updated successfully',
        );
      case SettingsSyncNow():
        value = value.copyWith(
          toastMessage: 'All data synchronized successfully',
        );
      case SettingsDismissToast():
        value = value.copyWith(clearToast: true);
    }
  }
}
