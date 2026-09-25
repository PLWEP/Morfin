import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final String cacheSizeText;
  final String? toastMessage;

  const SettingsState({
    this.cacheSizeText = '0 KB • Online Mode',
    this.toastMessage,
  });

  SettingsState copyWith({
    String? cacheSizeText,
    String? toastMessage,
    bool clearToast = false,
  }) {
    return SettingsState(
      cacheSizeText: cacheSizeText ?? this.cacheSizeText,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
    );
  }
}

sealed class SettingsAction {
  const SettingsAction();
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
