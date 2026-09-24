import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool isOfflineModeEnabled;
  final bool isEscalationAlertsEnabled;
  final String syncChannel;
  final String cacheSizeText;
  final String? toastMessage;

  const SettingsState({
    this.isOfflineModeEnabled = true,
    this.isEscalationAlertsEnabled = true,
    this.syncChannel = 'Real-time (WS)',
    this.cacheSizeText = '128 MB used • 14 pending manifests',
    this.toastMessage,
  });

  SettingsState copyWith({
    bool? isOfflineModeEnabled,
    bool? isEscalationAlertsEnabled,
    String? syncChannel,
    String? cacheSizeText,
    String? toastMessage,
    bool clearToast = false,
  }) {
    return SettingsState(
      isOfflineModeEnabled: isOfflineModeEnabled ?? this.isOfflineModeEnabled,
      isEscalationAlertsEnabled:
          isEscalationAlertsEnabled ?? this.isEscalationAlertsEnabled,
      syncChannel: syncChannel ?? this.syncChannel,
      cacheSizeText: cacheSizeText ?? this.cacheSizeText,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
    );
  }
}

sealed class SettingsAction {
  const SettingsAction();
}

class SettingsToggleOfflineMode extends SettingsAction {
  final bool value;
  const SettingsToggleOfflineMode(this.value);
}

class SettingsToggleEscalationAlerts extends SettingsAction {
  final bool value;
  const SettingsToggleEscalationAlerts(this.value);
}

class SettingsClearCache extends SettingsAction {
  const SettingsClearCache();
}

class SettingsExportLogs extends SettingsAction {
  const SettingsExportLogs();
}

class SettingsLockTerminal extends SettingsAction {
  const SettingsLockTerminal();
}

class SettingsDismissToast extends SettingsAction {
  const SettingsDismissToast();
}

class SettingsChangePassword extends SettingsAction {
  final String newPassword;
  const SettingsChangePassword(this.newPassword);
}
