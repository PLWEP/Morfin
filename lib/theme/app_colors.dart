import 'package:flutter/material.dart';

class AppPalette {
  final bool isDark;
  final Color surfaceDeep;
  final Color surfaceCard;
  final Color surface;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceBorder;

  final Color primary;
  final Color primaryLight;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color statusActive;
  final Color statusWarning;
  final Color statusSuccess;
  final Color statusCritical;

  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onSurfaceMuted;
  final Color outline;
  final Color outlineVariant;

  const AppPalette({
    required this.isDark,
    required this.surfaceDeep,
    required this.surfaceCard,
    required this.surface,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceBorder,
    required this.primary,
    required this.primaryLight,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.statusActive,
    required this.statusWarning,
    required this.statusSuccess,
    required this.statusCritical,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    required this.outline,
    required this.outlineVariant,
  });
}

class AppColors {
  AppColors._();

  // Dark Palette (Kinetic Industrial Terminal)
  static const dark = AppPalette(
    isDark: true,
    surfaceDeep: Color(0xFF080B11),
    surfaceCard: Color(0xFF111726),
    surface: Color(0xFF0F131C),
    surfaceContainerLow: Color(0xFF181C24),
    surfaceContainer: Color(0xFF1C2028),
    surfaceContainerHigh: Color(0xFF262A33),
    surfaceBorder: Color(0xFF1E293B),
    primary: Color(0xFF2563EB),
    primaryLight: Color(0xFFB4C5FF),
    primaryContainer: Color(0xFF2563EB),
    onPrimaryContainer: Color(0xFFEEEFFF),
    statusActive: Color(0xFF00F5FF),
    statusWarning: Color(0xFFF59E0B),
    statusSuccess: Color(0xFF10B981),
    statusCritical: Color(0xFFEF4444),
    onSurface: Color(0xFFDFE2EE),
    onSurfaceVariant: Color(0xFF8D90A0),
    onSurfaceMuted: Color(0xFF5A6175),
    outline: Color(0xFF8D90A0),
    outlineVariant: Color(0xFF434655),
  );

  // Light Palette (Clean Industrial Slate)
  static const light = AppPalette(
    isDark: false,
    surfaceDeep: Color(0xFFF1F5F9),
    surfaceCard: Color(0xFFFFFFFF),
    surface: Color(0xFFF8FAFC),
    surfaceContainerLow: Color(0xFFF1F5F9),
    surfaceContainer: Color(0xFFE2E8F0),
    surfaceContainerHigh: Color(0xFFF8FAFC),
    surfaceBorder: Color(0xFFCBD5E1),
    primary: Color(0xFF2563EB),
    primaryLight: Color(0xFF1D4ED8),
    primaryContainer: Color(0xFF2563EB),
    onPrimaryContainer: Colors.white,
    statusActive: Color(0xFF0284C7),
    statusWarning: Color(0xFFD97706),
    statusSuccess: Color(0xFF059669),
    statusCritical: Color(0xFFDC2626),
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF475569),
    onSurfaceMuted: Color(0xFF94A3B8),
    outline: Color(0xFF64748B),
    outlineVariant: Color(0xFFCBD5E1),
  );

  static AppPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  // Fallback static aliases referencing dark default
  static const Color surfaceDeep = Color(0xFF080B11);
  static const Color surfaceCard = Color(0xFF111726);
  static const Color surface = Color(0xFF0F131C);
  static const Color surfaceContainerLow = Color(0xFF181C24);
  static const Color surfaceContainer = Color(0xFF1C2028);
  static const Color surfaceContainerHigh = Color(0xFF262A33);
  static const Color surfaceBorder = Color(0xFF1E293B);
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFB4C5FF);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color onPrimaryContainer = Color(0xFFEEEFFF);
  static const Color statusActive = Color(0xFF00F5FF);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusCritical = Color(0xFFEF4444);
  static const Color onSurface = Color(0xFFDFE2EE);
  static const Color onSurfaceVariant = Color(0xFF8D90A0);
  static const Color onSurfaceMuted = Color(0xFF5A6175);
  static const Color outline = Color(0xFF8D90A0);
  static const Color outlineVariant = Color(0xFF434655);
}
