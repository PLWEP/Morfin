import 'package:flutter/material.dart';
import 'menu_contract.dart';
import 'menu_mock_data.dart';

class MenuViewModel extends ValueNotifier<MenuState> {
  MenuViewModel() : super(const MenuState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    value = value.copyWith(
      quickDispatches: MenuMockData.quickDispatches,
      modules: MenuMockData.modules,
    );
  }

  void dispatch(MenuAction action) {
    switch (action) {
      case MenuSearchQueryChanged(:final query):
        value = value.copyWith(searchQuery: query);
      case MenuCategoryChanged(:final category):
        value = value.copyWith(selectedCategory: category);
      case MenuModuleSelected(:final moduleId):
        debugPrint('Module selected: $moduleId');
    }
  }
}
