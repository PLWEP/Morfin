class MockEntityStore {
  MockEntityStore._();

  static final List<Map<String, dynamic>> workOrders = [
    {
      'id': 'wo-1',
      'code': 'WO-8901',
      'title': 'Hydraulic Pump Seal Replacement',
      'assetName': 'Pump HP-01',
      'location': 'Sector 4',
      'priority': 'Critical',
      'status': 'In Progress',
      'assignedTo': 'Budi Santoso',
      'dueDate': 'Today',
      'description': 'Replace leaking mechanical seal on primary hydraulic supply unit.',
    },
    {
      'id': 'wo-2',
      'code': 'WO-8902',
      'title': 'Conveyor Belt Tension Alignment',
      'assetName': 'Conveyor CV-03',
      'location': 'Packaging Line',
      'priority': 'High',
      'status': 'Pending',
      'assignedTo': 'Ahmad Fauzi',
      'dueDate': 'Tomorrow',
      'description': 'Calibrate belt tracking tension to eliminate side slippage.',
    },
    {
      'id': 'wo-3',
      'code': 'WO-8903',
      'title': 'Monthly Motor Vibration Inspection',
      'assetName': 'Induction Motor M-12',
      'location': 'Compressor Room',
      'priority': 'Medium',
      'status': 'Completed',
      'assignedTo': 'Dewi Lestari',
      'dueDate': '28 Sep',
      'description': 'Measure harmonic vibration frequencies across drive and non-drive bearings.',
    },
  ];

  static final List<Map<String, dynamic>> inventory = [
    {
      'id': 'inv-1',
      'code': 'SKF-6205-2RS',
      'name': 'Deep Groove Ball Bearing 25x52x15mm',
      'category': 'Mechanical',
      'quantity': '18 pcs',
      'binLocation': 'Rack B-03',
      'status': 'In Stock',
      'lastRestocked': '2026-09-15',
    },
    {
      'id': 'inv-2',
      'code': 'FKM-O-75X3',
      'name': 'Fluorocarbon O-Ring 75x3mm Viton',
      'category': 'Pneumatic / Seals',
      'quantity': '4 pcs',
      'binLocation': 'Drawer C-12',
      'status': 'Low Stock',
      'lastRestocked': '2026-08-20',
    },
    {
      'id': 'inv-3',
      'code': 'SIEM-3RT2015',
      'name': 'Sirius Power Contactor 24VDC',
      'category': 'Electrical',
      'quantity': '0 pcs',
      'binLocation': 'Cabinet E-01',
      'status': 'Out of Stock',
      'lastRestocked': '2026-07-10',
    },
  ];

  static void addWorkOrder(Map<String, dynamic> data) {
    final nextId = workOrders.length + 1;
    workOrders.insert(0, {
      'id': 'wo-$nextId',
      'code': 'WO-${8900 + nextId}',
      'title': data['title'] ?? 'New Directive',
      'assetName': data['assetName'] ?? 'General Asset',
      'location': data['location'] ?? 'Plant Floor',
      'priority': data['priority'] ?? 'Medium',
      'status': 'Pending',
      'assignedTo': data['assignedTo'] ?? 'You',
      'dueDate': data['dueDate'] ?? 'Today',
      'description': data['description'] ?? '',
    });
  }

  static void updateOrderStatus(String code, String newStatus) {
    for (final order in workOrders) {
      if (order['code'] == code) {
        order['status'] = newStatus;
        break;
      }
    }
  }

  static void updateInventoryStock(String code, int delta) {
    for (final item in inventory) {
      if (item['code'] == code) {
        final currentStr = item['quantity']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0';
        final newQty = ((int.tryParse(currentStr) ?? 0) + delta).clamp(0, 99999);
        item['quantity'] = '$newQty pcs';
        item['status'] = newQty == 0 ? 'Out of Stock' : (newQty <= 5 ? 'Low Stock' : 'In Stock');
        break;
      }
    }
  }
}
