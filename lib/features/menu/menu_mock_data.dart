import 'menu_contract.dart';
import 'menu_modules_data.dart';
import 'menu_quick_dispatch_data.dart';

abstract final class MenuMockData {
  static const List<QuickDispatchItem> quickDispatches =
      MenuQuickDispatchData.items;

  static const List<ModuleItem> modules = MenuModulesData.items;
}
