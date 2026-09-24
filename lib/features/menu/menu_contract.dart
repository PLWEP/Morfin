import 'package:flutter/material.dart';

enum ModuleBadgeType { active, warning, critical, success, hardware, none }

class ModuleItem {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final String? badgeText;
  final ModuleBadgeType badgeType;

  const ModuleItem({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    this.badgeText,
    this.badgeType = ModuleBadgeType.none,
  });
}

@immutable
class MenuState {
  final String searchQuery;
  final String selectedCategory;
  final List<ModuleItem> modules;

  const MenuState({
    this.searchQuery = '',
    this.selectedCategory = 'all',
    this.modules = const [],
  });

  List<ModuleItem> get filteredModules {
    return modules.where((m) {
      final matchesCategory =
          selectedCategory == 'all' || m.category == selectedCategory;
      final matchesQuery = searchQuery.isEmpty ||
          m.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          m.subtitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
          m.code.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  MenuState copyWith({
    String? searchQuery,
    String? selectedCategory,
    List<ModuleItem>? modules,
  }) {
    return MenuState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      modules: modules ?? this.modules,
    );
  }
}

sealed class MenuAction {
  const MenuAction();
}

class MenuSearchQueryChanged extends MenuAction {
  final String query;
  const MenuSearchQueryChanged(this.query);
}

class MenuCategoryChanged extends MenuAction {
  final String category;
  const MenuCategoryChanged(this.category);
}

class MenuModuleSelected extends MenuAction {
  final String moduleId;
  const MenuModuleSelected(this.moduleId);
}
