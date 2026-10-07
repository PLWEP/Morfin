import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final String cacheSizeText;
  final String? toastMessage;
  final bool isIndustrialMode;
  final bool isSoundEnabled;

  const SettingsState({
    this.cacheSizeText = '0 KB • Online Mode',
    this.toastMessage,
    this.isIndustrialMode = false,
    this.isSoundEnabled = true,
  });

  SettingsState copyWith({
    String? cacheSizeText,
    String? toastMessage,
    bool? isIndustrialMode,
    bool? isSoundEnabled,
    bool clearToast = false,
  }) {
    return SettingsState(
      cacheSizeText: cacheSizeText ?? this.cacheSizeText,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      isIndustrialMode: isIndustrialMode ?? this.isIndustrialMode,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
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

class SettingsToggleIndustrialMode extends SettingsAction {
  final bool enabled;
  const SettingsToggleIndustrialMode(this.enabled);
}

class SettingsToggleSoundFeedback extends SettingsAction {
  final bool enabled;
  const SettingsToggleSoundFeedback(this.enabled);
}
