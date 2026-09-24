import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ColorResolver {
  const ColorResolver._();

  static Color resolve(String? token, BuildContext context, {Color? fallback}) {
    final colors = AppColors.of(context);
    final defaultColor = fallback ?? colors.primary;

    if (token == null || token.isEmpty) return defaultColor;

    final lower = token.toLowerCase().trim();
    switch (lower) {
      case 'success':
        return colors.statusSuccess;
      case 'warning':
        return colors.statusWarning;
      case 'critical':
      case 'error':
        return colors.statusCritical;
      case 'info':
      case 'active':
        return colors.statusActive;
      case 'primary':
      case 'accent':
        return colors.primary;
      case 'secondary':
        return colors.primaryLight;
      case 'textmuted':
        return colors.onSurfaceMuted;
    }

    if (token.startsWith('#')) {
      final hex = token.replaceFirst('#', '');
      if (hex.length == 6) {
        final val = int.tryParse('FF$hex', radix: 16);
        if (val != null) return Color(val);
      } else if (hex.length == 8) {
        final val = int.tryParse(hex, radix: 16);
        if (val != null) return Color(val);
      }
    }

    return defaultColor;
  }
}
