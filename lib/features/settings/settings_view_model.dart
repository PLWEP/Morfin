import 'package:flutter/material.dart';
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
          toastMessage: 'Escalation Filter: ${val ? "Active" : "Disabled"}',
        );
      case SettingsToggleBiometrics(value: final val):
        value = value.copyWith(
          isBiometricsEnabled: val,
          toastMessage: 'Biometric Gateway: ${val ? "Armed" : "Disarmed"}',
        );
      case SettingsClearCache():
        value = value.copyWith(
          cacheSizeText: '0 MB used • Cache purged',
          toastMessage: 'Local manifest cache cleared (0 MB)',
        );
      case SettingsExportLogs():
        value = value.copyWith(
          toastMessage: 'System Telemetry encrypted & exported',
        );
      case SettingsLockTerminal():
        value = value.copyWith(
          toastMessage: 'Locking Terminal Node Sec-04...',
        );
      case SettingsDismissToast():
        value = value.copyWith(clearToast: true);
    }
  }
}
