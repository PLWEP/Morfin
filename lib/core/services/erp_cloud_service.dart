import 'package:dio/dio.dart';
import '../metadata/mock_entity_service.dart';
import '../network/api_client.dart';
import '../network/odata_query.dart';

class ErpCloudService {
  static final ErpCloudService instance = ErpCloudService._();
  final ApiClient _client = ApiClient.instance;

  ErpCloudService._();

  static const String woProjection = 'ActiveSeparateWorkOrdersHandling';
  static const String woEntitySet = 'ActiveSeparateWorkOrderSet';

  static const String invProjection = 'InventoryPartsHandling';
  static const String invEntitySet = 'InventoryPartSet';

  Future<List<Map<String, dynamic>>> fetchWorkOrders({String? filter}) async {
    try {
      final query = ODataQuery(
        filter: filter,
        select: ['OrderNo', 'ErrDescr', 'Contract', 'MchCode', 'WorkLeaderSign', 'PlanSDate'],
        top: 50,
      );

      final rawList = await _client.getEntitySet(woProjection, woEntitySet, query: query);
      if (rawList.isNotEmpty) {
        return rawList.map((row) {
          return {
            'id': row['OrderNo']?.toString() ?? '',
            'code': 'WO-${row['OrderNo']}',
            'title': row['ErrDescr']?.toString() ?? 'Work Order',
            'assetName': row['MchCode']?.toString() ?? 'Plant Asset',
            'location': row['Contract']?.toString() ?? 'Site 1',
            'priority': row['Priority']?.toString() ?? 'Medium',
            'status': row['Objstate']?.toString() ?? 'In Progress',
            'assignedTo': row['WorkLeaderSign']?.toString() ?? 'Engineer',
            'dueDate': row['PlanSDate']?.toString() ?? 'Today',
            'description': row['WorkDescr']?.toString() ?? '',
          };
        }).toList();
      }
    } on DioException {
      // Fallback to store on live network disconnect
    }
    return MockEntityService.fetchLiveWorkOrders();
  }

  Future<void> executeWorkOrderAction(String actionName, Map<String, dynamic> data) async {
    try {
      if (actionName == 'create') {
        await _client.postEntity(woProjection, woEntitySet, {
          'ErrDescr': data['title'],
          'MchCode': data['assetName'],
          'Contract': data['location'],
          'Priority': data['priority'],
          'PlanSDate': data['dueDate'],
        });
        return;
      }
    } on DioException {
      // Fallback to local store mutation
    }
    await MockEntityService.executeWorkOrderAction(actionName, data);
  }

  Future<List<Map<String, dynamic>>> fetchInventory({String? filter}) async {
    try {
      final query = ODataQuery(
        filter: filter,
        select: ['PartNo', 'Description', 'Contract', 'UnitMeas', 'QtyOnHand'],
        top: 50,
      );

      final rawList = await _client.getEntitySet(invProjection, invEntitySet, query: query);
      if (rawList.isNotEmpty) {
        return rawList.map((row) {
          final qty = (row['QtyOnHand'] as num?)?.toInt() ?? 0;
          return {
            'id': row['PartNo']?.toString() ?? '',
            'code': row['PartNo']?.toString() ?? '',
            'name': row['Description']?.toString() ?? 'Spare Part',
            'category': row['PartProductFamily']?.toString() ?? 'Mechanical',
            'quantity': '$qty ${row['UnitMeas'] ?? 'pcs'}',
            'binLocation': row['Contract']?.toString() ?? 'Warehouse',
            'status': qty == 0 ? 'Out of Stock' : (qty <= 5 ? 'Low Stock' : 'In Stock'),
            'lastRestocked': row['LatestActivityDate']?.toString() ?? 'Recent',
          };
        }).toList();
      }
    } on DioException {
      // Fallback to store on live network disconnect
    }
    return MockEntityService.fetchLiveInventory();
  }

  Future<void> executeInventoryAction(String actionName, Map<String, dynamic> data) async {
    try {
      if (actionName == 'adjust_stock') {
        final delta = int.tryParse(data['delta']?.toString() ?? '0') ?? 0;
        await _client.callAction(invProjection, 'AdjustPartQuantity', {
          'PartNo': data['code'],
          'Delta': delta,
        });
        return;
      }
    } on DioException {
      // Fallback to local store mutation
    }
    await MockEntityService.executeInventoryAction(actionName, data);
  }
}
