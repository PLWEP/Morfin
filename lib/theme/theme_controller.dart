import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.dark);

  static final ThemeController instance = ThemeController._();

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    value = mode;
  }
}
