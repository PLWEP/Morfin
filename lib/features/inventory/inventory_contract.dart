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

  Map<String, dynamic> toJson() => {
        'id': id, 'code': code, 'name': name, 'category': category,
        'quantity': quantity, 'minThreshold': minThreshold, 'unit': unit,
        'binLocation': binLocation, 'status': status.name,
        'lastRestocked': lastRestocked,
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 0,
        minThreshold: json['minThreshold'] as int? ?? 0,
        unit: json['unit'] as String? ?? '',
        binLocation: json['binLocation'] as String? ?? '',
        status: StockStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => StockStatus.inStock,
        ),
        lastRestocked: json['lastRestocked'] as String? ?? '',
      );
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
