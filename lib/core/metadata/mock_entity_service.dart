import 'entity_metadata.dart';

class MockEntityService {
  const MockEntityService._();

  static final EntitySchemaMetadata workOrderSchema = EntitySchemaMetadata(
    entityName: 'WorkOrder',
    title: 'Work Orders',
    icon: 'assignment',
    fields: const [
      EntityFieldMetadata(key: 'code', label: 'Order ID', isKey: true),
      EntityFieldMetadata(key: 'title', label: 'Directive'),
      EntityFieldMetadata(key: 'assetName', label: 'Equipment Asset'),
      EntityFieldMetadata(key: 'location', label: 'Plant Location'),
      EntityFieldMetadata(key: 'priority', label: 'Priority', type: FieldType.priority),
      EntityFieldMetadata(key: 'status', label: 'Execution State', type: FieldType.status),
      EntityFieldMetadata(key: 'assignedTo', label: 'Assigned Engineer'),
      EntityFieldMetadata(key: 'dueDate', label: 'Due Date', type: FieldType.date),
      EntityFieldMetadata(key: 'description', label: 'Work Scope'),
    ],
    listCard: const EntityListCardMetadata(
      codeField: 'code',
      primaryField: 'title',
      secondaryField: 'assetName',
      tertiaryField: 'location',
      statusField: 'status',
      priorityField: 'priority',
      metricField: 'dueDate',
    ),
  );

  static Future<List<Map<String, dynamic>>> fetchLiveWorkOrders() async {
    // Simulates live network roundtrip to backend ERP API
    await Future.delayed(const Duration(milliseconds: 300));
    return [
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
      {
        'id': 'wo-4',
        'code': 'WO-8904',
        'title': 'Air Filter Cartridge Renewal',
        'assetName': 'Pneumatic System AC-02',
        'location': 'HVAC Deck',
        'priority': 'Low',
        'status': 'Pending',
        'assignedTo': 'You',
        'dueDate': '30 Sep',
        'description': 'Routine preventive replacement of coalescing particulate air filters.',
      },
    ];
  }

  static final EntitySchemaMetadata inventorySchema = EntitySchemaMetadata(
    entityName: 'InventoryPart',
    title: 'Spare Parts Inventory',
    icon: 'inventory_2',
    fields: const [
      EntityFieldMetadata(key: 'code', label: 'Part Number', isKey: true),
      EntityFieldMetadata(key: 'name', label: 'Description'),
      EntityFieldMetadata(key: 'category', label: 'Classification'),
      EntityFieldMetadata(key: 'quantity', label: 'Available Stock', type: FieldType.number),
      EntityFieldMetadata(key: 'binLocation', label: 'Warehouse Bin'),
      EntityFieldMetadata(key: 'status', label: 'Inventory State', type: FieldType.status),
      EntityFieldMetadata(key: 'lastRestocked', label: 'Last Restock Date', type: FieldType.date),
    ],
    listCard: const EntityListCardMetadata(
      codeField: 'code',
      primaryField: 'name',
      secondaryField: 'category',
      tertiaryField: 'binLocation',
      statusField: 'status',
      metricField: 'quantity',
    ),
  );

  static Future<List<Map<String, dynamic>>> fetchLiveInventory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
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
  }
}
