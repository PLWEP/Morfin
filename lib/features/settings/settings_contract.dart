import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool isEscalationAlertsEnabled;
  final String cacheSizeText;
  final String? toastMessage;

  const SettingsState({
    this.isEscalationAlertsEnabled = true,
    this.cacheSizeText = '0 KB • Online Mode',
    this.toastMessage,
  });

  SettingsState copyWith({
    bool? isEscalationAlertsEnabled,
    String? cacheSizeText,
    String? toastMessage,
    bool clearToast = false,
  }) {
    return SettingsState(
      isEscalationAlertsEnabled:
          isEscalationAlertsEnabled ?? this.isEscalationAlertsEnabled,
      cacheSizeText: cacheSizeText ?? this.cacheSizeText,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
    );
  }
}

sealed class SettingsAction {
  const SettingsAction();
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
