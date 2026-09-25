import 'entity_metadata.dart';

class EntitySchemaRegistry {
  const EntitySchemaRegistry._();

  static final EntitySchemaMetadata workOrderSchema = EntitySchemaMetadata(
    entityName: 'WorkOrder',
    title: 'Work Orders',
    icon: 'assignment',
    projection: 'ActiveSeparateWorkOrdersHandling',
    entitySet: 'ActiveSeparateWorkOrderSet',
    actions: const [
      EntityActionMetadata(
        name: 'create',
        label: 'New Work Order',
        icon: 'add',
        scope: ActionScope.global,
        formFields: [
          EntityFieldMetadata(key: 'ErrDescr', label: 'Directive Title', isRequired: true),
          EntityFieldMetadata(key: 'MchCode', label: 'Equipment Asset', isRequired: true),
          EntityFieldMetadata(key: 'Contract', label: 'Plant Site', isRequired: true),
          EntityFieldMetadata(
            key: 'Priority',
            label: 'Priority',
            type: FieldType.priority,
            options: ['Critical', 'High', 'Medium', 'Low'],
          ),
          EntityFieldMetadata(key: 'PlanSDate', label: 'Planned Start Date', isRequired: true),
        ],
      ),
      EntityActionMetadata(
        name: 'change_status',
        label: 'Change Status',
        icon: 'swap_horiz',
        scope: ActionScope.record,
        formFields: [
          EntityFieldMetadata(
            key: 'Objstate',
            label: 'Execution State',
            type: FieldType.status,
            options: ['Pending', 'In Progress', 'Completed', 'Cancelled'],
          ),
        ],
      ),
    ],
    fields: const [
      EntityFieldMetadata(key: 'OrderNo', label: 'Order ID', isKey: true),
      EntityFieldMetadata(key: 'ErrDescr', label: 'Directive'),
      EntityFieldMetadata(key: 'MchCode', label: 'Equipment Asset'),
      EntityFieldMetadata(key: 'Contract', label: 'Plant Site'),
      EntityFieldMetadata(key: 'Priority', label: 'Priority', type: FieldType.priority),
      EntityFieldMetadata(key: 'Objstate', label: 'Execution State', type: FieldType.status),
      EntityFieldMetadata(key: 'WorkLeaderSign', label: 'Assigned Engineer'),
      EntityFieldMetadata(key: 'PlanSDate', label: 'Due Date', type: FieldType.date),
      EntityFieldMetadata(key: 'WorkDescr', label: 'Work Scope'),
    ],
    listCard: const EntityListCardMetadata(
      codeField: 'OrderNo',
      primaryField: 'ErrDescr',
      secondaryField: 'MchCode',
      tertiaryField: 'Contract',
      statusField: 'Objstate',
      priorityField: 'Priority',
      metricField: 'PlanSDate',
    ),
  );

  static final EntitySchemaMetadata inventorySchema = EntitySchemaMetadata(
    entityName: 'InventoryPart',
    title: 'Spare Parts Inventory',
    icon: 'inventory_2',
    projection: 'InventoryPartsHandling',
    entitySet: 'InventoryPartSet',
    actions: const [
      EntityActionMetadata(
        name: 'AdjustPartQuantity',
        label: 'Adjust Stock Quantity',
        icon: 'add_circle',
        scope: ActionScope.record,
        formFields: [
          EntityFieldMetadata(
            key: 'Delta',
            label: 'Quantity Delta (e.g. 5 or -2)',
            type: FieldType.number,
            isRequired: true,
          ),
        ],
      ),
    ],
    fields: const [
      EntityFieldMetadata(key: 'PartNo', label: 'Part Number', isKey: true),
      EntityFieldMetadata(key: 'Description', label: 'Description'),
      EntityFieldMetadata(key: 'PartProductFamily', label: 'Classification'),
      EntityFieldMetadata(key: 'QtyOnHand', label: 'Available Stock', type: FieldType.number),
      EntityFieldMetadata(key: 'Contract', label: 'Warehouse Site'),
      EntityFieldMetadata(key: 'UnitMeas', label: 'Unit'),
    ],
    listCard: const EntityListCardMetadata(
      codeField: 'PartNo',
      primaryField: 'Description',
      secondaryField: 'PartProductFamily',
      tertiaryField: 'Contract',
      statusField: 'UnitMeas',
      metricField: 'QtyOnHand',
    ),
  );

  static EntitySchemaMetadata? findByTarget(String target) {
    final clean = target.replaceAll('/', '').toLowerCase();
    switch (clean) {
      case 'work_orders':
      case 'wo_exec':
      case 'workorders':
      case 'activeseparateworkordershandling':
        return workOrderSchema;
      case 'inventory':
      case 'inv_part':
      case 'inventoryparts':
      case 'inventorypartshandling':
        return inventorySchema;
      default:
        return null;
    }
  }
}
