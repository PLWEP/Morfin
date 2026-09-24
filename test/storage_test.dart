import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morfin/core/storage/local_storage_service.dart';
import 'package:morfin/features/inventory/inventory_contract.dart';
import 'package:morfin/features/work_orders/work_order_contract.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LocalStorageService persists theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    expect(storage.getThemeMode(), isNull);
    await storage.saveThemeMode('light');
    expect(storage.getThemeMode(), equals('light'));
  });

  test('LocalStorageService persists work orders', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    const sample = WorkOrder(
      id: 'wo-1',
      code: 'WO-100',
      title: 'Inspect pump',
      assetName: 'Pump A',
      location: 'Sector 4',
      priority: WorkOrderPriority.high,
      status: WorkOrderStatus.inProgress,
      assignedTo: 'Engineer',
      dueDate: 'Today',
      description: 'Check bearings',
      checklist: [
        WorkOrderChecklist(id: 'c1', label: 'Check oil', isDone: true),
      ],
    );

    await storage.saveWorkOrders([sample]);
    final loaded = storage.getWorkOrders();
    expect(loaded, isNotNull);
    expect(loaded!.length, equals(1));
    expect(loaded.first.title, equals('Inspect pump'));
    expect(loaded.first.checklist.first.isDone, isTrue);
  });

  test('LocalStorageService persists inventory items', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);

    const item = InventoryItem(
      id: 'inv-1',
      code: 'INV-10',
      name: 'Flange Gasket',
      category: 'Mechanical',
      quantity: 12,
      minThreshold: 5,
      unit: 'pcs',
      binLocation: 'A-12',
      status: StockStatus.inStock,
      lastRestocked: '2026-09-01',
    );

    await storage.saveInventoryItems([item]);
    final loaded = storage.getInventoryItems();
    expect(loaded, isNotNull);
    expect(loaded!.length, equals(1));
    expect(loaded.first.quantity, equals(12));
    expect(loaded.first.status, equals(StockStatus.inStock));
  });
}
