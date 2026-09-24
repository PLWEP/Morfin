import 'entity_metadata.dart';
import 'mock_entity_store.dart';

class MockEntityService {
  const MockEntityService._();

  static final EntitySchemaMetadata workOrderSchema = EntitySchemaMetadata(
    entityName: 'WorkOrder',
    title: 'Work Orders',
    icon: 'assignment',
    actions: const [
      EntityActionMetadata(
        name: 'create',
        label: 'New Work Order',
        icon: 'add',
        scope: ActionScope.global,
        formFields: [
          EntityFieldMetadata(key: 'title', label: 'Directive Title', isRequired: true),
          EntityFieldMetadata(key: 'assetName', label: 'Equipment Asset', isRequired: true),
          EntityFieldMetadata(key: 'location', label: 'Plant Location', isRequired: true),
          EntityFieldMetadata(
            key: 'priority',
            label: 'Priority',
            type: FieldType.priority,
            options: ['Critical', 'High', 'Medium', 'Low'],
          ),
          EntityFieldMetadata(key: 'dueDate', label: 'Due Date', isRequired: true),
          EntityFieldMetadata(key: 'description', label: 'Scope Description'),
        ],
      ),
      EntityActionMetadata(
        name: 'change_status',
        label: 'Change Status',
        icon: 'swap_horiz',
        scope: ActionScope.record,
        formFields: [
          EntityFieldMetadata(
            key: 'status',
            label: 'Execution State',
            type: FieldType.status,
            options: ['Pending', 'In Progress', 'Completed', 'Cancelled'],
          ),
        ],
      ),
    ],
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
    await Future.delayed(const Duration(milliseconds: 250));
    return List<Map<String, dynamic>>.from(MockEntityStore.workOrders);
  }

  static Future<void> executeWorkOrderAction(String actionName, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (actionName == 'create') {
      MockEntityStore.addWorkOrder(data);
    } else if (actionName == 'change_status') {
      MockEntityStore.updateOrderStatus(data['code'] ?? '', data['status'] ?? 'Pending');
    }
  }

  static final EntitySchemaMetadata inventorySchema = EntitySchemaMetadata(
    entityName: 'InventoryPart',
    title: 'Spare Parts Inventory',
    icon: 'inventory_2',
    actions: const [
      EntityActionMetadata(
        name: 'adjust_stock',
        label: 'Adjust Stock',
        icon: 'add_circle',
        scope: ActionScope.record,
        formFields: [
          EntityFieldMetadata(
            key: 'delta',
            label: 'Quantity Delta (e.g. 5 or -2)',
            type: FieldType.number,
            isRequired: true,
          ),
        ],
      ),
    ],
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
    await Future.delayed(const Duration(milliseconds: 250));
    return List<Map<String, dynamic>>.from(MockEntityStore.inventory);
  }

  static Future<void> executeInventoryAction(String actionName, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (actionName == 'adjust_stock') {
      final delta = int.tryParse(data['delta']?.toString() ?? '0') ?? 0;
      MockEntityStore.updateInventoryStock(data['code'] ?? '', delta);
    }
  }
}
