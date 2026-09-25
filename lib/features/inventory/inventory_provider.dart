import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage_service.dart';
import 'inventory_contract.dart';

class InventoryNotifier extends Notifier<InventoryState> {
  @override
  InventoryState build() {
    final storage = ref.watch(localStorageServiceProvider);
    final saved = storage.getInventoryItems();
    return InventoryState(items: saved ?? const []);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void adjustStock(String itemId, int delta) {
    final updated = state.items.map((item) {
      if (item.id != itemId) return item;
      final newQty = (item.quantity + delta).clamp(0, 99999);
      final newStatus = newQty == 0
          ? StockStatus.outOfStock
          : newQty <= item.minThreshold
              ? StockStatus.lowStock
              : StockStatus.inStock;
      return item.copyWith(quantity: newQty, status: newStatus);
    }).toList();

    state = state.copyWith(items: updated);
    ref.read(localStorageServiceProvider).saveInventoryItems(updated);
  }

  InventoryItem? getItemById(String id) {
    try {
      return state.items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}

final inventoryProvider = NotifierProvider<InventoryNotifier, InventoryState>(
  InventoryNotifier.new,
);
