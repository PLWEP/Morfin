import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import 'settings_contract.dart';

class SettingsViewModel extends ValueNotifier<SettingsState> {
  SettingsViewModel() : super(const SettingsState());

  void dispatch(SettingsAction action) {
    switch (action) {
      case SettingsToggleEscalationAlerts(value: final val):
        value = value.copyWith(
          isEscalationAlertsEnabled: val,
          toastMessage: 'Notifications: ${val ? "Enabled" : "Disabled"}',
        );
      case SettingsClearCache():
        value = value.copyWith(
          cacheSizeText: '0 KB used • Cache cleared',
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
      case SettingsDismissToast():
        value = value.copyWith(clearToast: true);
    }
  }
}
