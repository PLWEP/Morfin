import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'menu_contract.dart';

class MenuNotifier extends Notifier<MenuState> {
  @override
  MenuState build() {
    return const MenuState(modules: []);
  }

  void dispatch(MenuAction action) {
    switch (action) {
      case MenuSearchQueryChanged(:final query):
        state = state.copyWith(searchQuery: query);
      case MenuCategoryChanged(:final category):
        state = state.copyWith(selectedCategory: category);
      case MenuModuleSelected(:final moduleId):
        debugPrint('Module selected: $moduleId');
    }
  }
}

final menuProvider = NotifierProvider<MenuNotifier, MenuState>(
  MenuNotifier.new,
);
