import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/inventory/inventory_contract.dart';
import '../../features/work_orders/work_order_contract.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

class LocalStorageService {
  final SharedPreferences _prefs;

  static const _keyTheme = 'app_theme_mode';
  static const _keyWorkOrders = 'app_work_orders';
  static const _keyInventory = 'app_inventory_items';

  const LocalStorageService(this._prefs);

  String? getThemeMode() => _prefs.getString(_keyTheme);

  Future<bool> saveThemeMode(String mode) => _prefs.setString(_keyTheme, mode);

  List<WorkOrder>? getWorkOrders() {
    final raw = _prefs.getString(_keyWorkOrders);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => WorkOrder.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveWorkOrders(List<WorkOrder> orders) {
    final encoded = jsonEncode(orders.map((o) => o.toJson()).toList());
    return _prefs.setString(_keyWorkOrders, encoded);
  }

  List<InventoryItem>? getInventoryItems() {
    final raw = _prefs.getString(_keyInventory);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveInventoryItems(List<InventoryItem> items) {
    final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
    return _prefs.setString(_keyInventory, encoded);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_keyTheme);
    await _prefs.remove(_keyWorkOrders);
    await _prefs.remove(_keyInventory);
  }
}
