import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/local_storage_service.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final storage = ref.watch(localStorageServiceProvider);
    final savedMode = storage.getThemeMode();
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    if (savedMode == 'system') return ThemeMode.system;
    return ThemeMode.dark;
  }

  bool get isDarkMode => state == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    ref.read(localStorageServiceProvider).saveThemeMode(isDark ? 'dark' : 'light');
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(localStorageServiceProvider).saveThemeMode(mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
