import 'package:flutter/material.dart';

class IconResolver {
  const IconResolver._();

  static const Map<String, IconData> _iconMap = {
    'dashboard': Icons.dashboard_outlined,
    'dashboard_rounded': Icons.dashboard_rounded,
    'assignment': Icons.assignment_outlined,
    'assignment_turned_in': Icons.assignment_turned_in_outlined,
    'inventory': Icons.inventory_2_outlined,
    'inventory_2': Icons.inventory_2_outlined,
    'precision_manufacturing': Icons.precision_manufacturing_outlined,
    'trending_up': Icons.trending_up_rounded,
    'trending_down': Icons.trending_down_rounded,
    'bolt': Icons.bolt_rounded,
    'speed': Icons.speed_rounded,
    'check_circle': Icons.check_circle_outline_rounded,
    'warning': Icons.warning_amber_rounded,
    'error': Icons.error_outline_rounded,
    'notifications': Icons.notifications_none_rounded,
    'settings': Icons.settings_outlined,
    'person': Icons.person_outline_rounded,
    'qr_code_scanner': Icons.qr_code_scanner_rounded,
    'analytics': Icons.analytics_outlined,
    'build': Icons.build_outlined,
    'schedule': Icons.schedule_rounded,
    'location_on': Icons.location_on_outlined,
    'info': Icons.info_outline_rounded,
    'swap_horiz': Icons.swap_horiz_rounded,
    'layers': Icons.layers_outlined,
    'folder': Icons.folder_outlined,
  };

  static IconData resolve(String? name, {IconData fallback = Icons.circle_outlined}) {
    if (name == null || name.isEmpty) return fallback;
    return _iconMap[name.toLowerCase().trim()] ?? fallback;
  }
}
