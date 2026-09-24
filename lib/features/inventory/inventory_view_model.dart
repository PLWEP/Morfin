import 'package:flutter/material.dart';
import 'inventory_contract.dart';
import 'inventory_mock_data.dart';

class InventoryViewModel extends ValueNotifier<InventoryState> {
  InventoryViewModel() : super(const InventoryState(items: InventoryMockData.items));

  void setFilter(String filter) {
    value = value.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);
  }

  void adjustStock(String itemId, int delta) {
    final updated = value.items.map((item) {
      if (item.id != itemId) return item;
      final newQty = (item.quantity + delta).clamp(0, 99999);
      final newStatus = newQty == 0
          ? StockStatus.outOfStock
          : newQty <= item.minThreshold
              ? StockStatus.lowStock
              : StockStatus.inStock;
      return item.copyWith(quantity: newQty, status: newStatus);
    }).toList();

    value = value.copyWith(items: updated);
  }

  InventoryItem? getItemById(String id) {
    try {
      return value.items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}
