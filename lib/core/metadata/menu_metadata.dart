import 'package:flutter/foundation.dart';
import 'action_metadata.dart';

@immutable
class MenuItemMetadata {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final String icon;
  final String category;
  final String? badgeText;
  final String badgeType;
  final ActionMetadata? action;

  const MenuItemMetadata({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    this.badgeText,
    this.badgeType = 'none',
    this.action,
  });

  factory MenuItemMetadata.fromJson(Map<String, dynamic> json) {
    return MenuItemMetadata(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      icon: json['icon'] as String? ?? 'folder',
      category: json['category'] as String? ?? 'General',
      badgeText: json['badgeText'] as String?,
      badgeType: json['badgeType'] as String? ?? 'none',
      action: json['action'] != null
          ? ActionMetadata.fromJson(json['action'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'subtitle': subtitle,
        'icon': icon,
        'category': category,
        if (badgeText != null) 'badgeText': badgeText,
        'badgeType': badgeType,
        if (action != null) 'action': action!.toJson(),
      };
}

@immutable
class MenuGroupMetadata {
  final String id;
  final String title;
  final String? icon;
  final List<MenuItemMetadata> items;

  const MenuGroupMetadata({
    required this.id,
    required this.title,
    this.icon,
    this.items = const [],
  });

  factory MenuGroupMetadata.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return MenuGroupMetadata(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String?,
      items: rawItems
          .map((i) => MenuItemMetadata.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (icon != null) 'icon': icon,
        'items': items.map((i) => i.toJson()).toList(),
      };
}

@immutable
class MenuMetadata {
  final String version;
  final List<MenuGroupMetadata> groups;

  const MenuMetadata({
    this.version = '1.0.0',
    this.groups = const [],
  });

  factory MenuMetadata.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['groups'] as List<dynamic>? ?? [];
    return MenuMetadata(
      version: json['version'] as String? ?? '1.0.0',
      groups: rawGroups
          .map((g) => MenuGroupMetadata.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }

  List<MenuItemMetadata> get allItems =>
      groups.expand((g) => g.items).toList();
}
