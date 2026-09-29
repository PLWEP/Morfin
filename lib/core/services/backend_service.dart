import 'dart:convert';
import '../network/api_client.dart';
import '../network/odata_query.dart';
import '../widgets/entity/entity_action_executor.dart';

class BackendService {
  static final BackendService instance = BackendService._();
  final ApiClient _client = ApiClient.instance;

  BackendService._();

  Future<List<Map<String, dynamic>>> fetchEntitySet({
    required String projection,
    required String entitySet,
    ODataQuery? query,
  }) async {
    return _client.getEntitySet(projection, entitySet, query: query);
  }

  Future<Map<String, dynamic>> fetchEntityRecord({
    required String projection,
    required String entitySet,
    required String key,
  }) async {
    return _client.getEntity(projection, entitySet, key);
  }

  Future<Map<String, dynamic>> createEntityRecord({
    required String projection,
    required String entitySet,
    required Map<String, dynamic> data,
  }) async {
    return _client.postEntity(projection, entitySet, data);
  }

  Future<Map<String, dynamic>> updateEntityRecord({
    required String projection,
    required String entitySet,
    required String key,
    required Map<String, dynamic> data,
  }) async {
    return _client.patchEntity(projection, entitySet, key, data);
  }

  Future<Map<String, dynamic>> executeAction({
    required String projection,
    required String actionName,
    required Map<String, dynamic> parameters,
  }) async {
    return _client.callAction(projection, actionName, parameters);
  }

  Future<Map<String, dynamic>> executeBatchAction({
    required String targetProjection,
    required String actionName,
    required List<Map<String, dynamic>> items,
  }) async {
    final keyListJson = jsonEncode(items.map((r) => EntityActionExecutor.sanitizePayload(r)).toList());
    return executeAction(
      projection: 'MobileNavMenuHandling',
      actionName: 'ExecuteBatchAction',
      parameters: {
        'TargetProjection': targetProjection,
        'ActionName': actionName,
        'KeyListJson': keyListJson,
      },
    );
  }

  Future<Map<String, dynamic>> executeFunction({
    required String projection,
    required String functionName,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _client.callFunction(projection, functionName, query: queryParameters);
  }

  Future<List<Map<String, dynamic>>> fetchNavigatorNodes({
    String scopeId = 'global',
    String deviceType = 'phone',
  }) async {
    try {
      final res = await executeFunction(
        projection: 'MobileNavMenu',
        functionName: "GetMobileMenu(ScopeId='$scopeId',DeviceType='$deviceType')",
      );
      final val = res['value'];
      if (val is List) {
        return val.map((i) => Map<String, dynamic>.from(i as Map)).toList();
      }
    } catch (_) {
      final res = await executeFunction(
        projection: 'MobileAppNavigator',
        functionName: "GetMobileMenu(ScopeId='$scopeId',DeviceType='$deviceType')",
      );
      final val = res['value'];
      if (val is List) {
        return val.map((i) => Map<String, dynamic>.from(i as Map)).toList();
      }
    }
    return [];
  }
}
