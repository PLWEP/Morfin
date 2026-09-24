import 'package:flutter/material.dart';

enum StockStatus {
  inStock('In Stock', Icons.check_circle_outline_rounded),
  lowStock('Low Stock', Icons.warning_amber_rounded),
  outOfStock('Out of Stock', Icons.error_outline_rounded);

  final String label;
  final IconData icon;
  const StockStatus(this.label, this.icon);
}

class InventoryItem {
  final String id;
  final String code;
  final String name;
  final String category;
  final int quantity;
  final int minThreshold;
  final String unit;
  final String binLocation;
  final StockStatus status;
  final String lastRestocked;

  const InventoryItem({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.quantity,
    required this.minThreshold,
    required this.unit,
    required this.binLocation,
    required this.status,
    required this.lastRestocked,
  });

  InventoryItem copyWith({int? quantity, StockStatus? status}) {
    return InventoryItem(
      id: id,
      code: code,
      name: name,
      category: category,
      quantity: quantity ?? this.quantity,
      minThreshold: minThreshold,
      unit: unit,
      binLocation: binLocation,
      status: status ?? this.status,
      lastRestocked: lastRestocked,
    );
  }
}

@immutable
class InventoryState {
  final List<InventoryItem> items;
  final String selectedFilter;
  final String searchQuery;

  const InventoryState({
    this.items = const [],
    this.selectedFilter = 'all',
    this.searchQuery = '',
  });

  List<InventoryItem> get filteredItems {
    return items.where((item) {
      final matchesFilter = switch (selectedFilter) {
        'lowStock' => item.status == StockStatus.lowStock,
        'inStock' => item.status == StockStatus.inStock,
        'outOfStock' => item.status == StockStatus.outOfStock,
        _ => true,
      };

      final matchesQuery = searchQuery.isEmpty ||
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.binLocation.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesQuery;
    }).toList();
  }

  InventoryState copyWith({
    List<InventoryItem>? items,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return InventoryState(
      items: items ?? this.items,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
