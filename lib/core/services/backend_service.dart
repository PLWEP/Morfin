import '../metadata/lobby_metadata.dart';
import '../metadata/metadata_service.dart';
import 'dart:convert';
import '../models/navigation_node.dart';
import '../network/api_client.dart';
import '../network/data_query.dart';
import '../utils/payload_utils.dart';

class BackendService {
  static final BackendService instance = BackendService._();
  final ApiClient _client = ApiClient.instance;

  BackendService._();

  Future<List<Map<String, dynamic>>> fetchCollection({
    required String projection,
    required String entitySet,
    DataQuery? query,
  }) async {
    return _client.getCollection(projection, entitySet, query: query);
  }

  Future<Map<String, dynamic>> fetchRecord({
    required String projection,
    required String entitySet,
    required String key,
  }) async {
    return _client.getRecord(projection, entitySet, key);
  }

  Future<Map<String, dynamic>> createRecord({
    required String projection,
    required String entitySet,
    required Map<String, dynamic> data,
  }) async {
    return _client.postRecord(projection, entitySet, data);
  }

  Future<Map<String, dynamic>> updateRecord({
    required String projection,
    required String entitySet,
    required String key,
    required Map<String, dynamic> data,
  }) async {
    return _client.patchRecord(projection, entitySet, key, data);
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
    final keyListJson = jsonEncode(items.map(PayloadUtils.sanitize).toList());
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
        projection: 'MobileNavMenuHandling',
        functionName: "GetMobileMenu(ScopeId='$scopeId',DeviceType='$deviceType')",
      );
      final val = res['value'];
      if (val is List && val.isNotEmpty) {
        return val.map((i) => NavigationNode.fromJson(Map<String, dynamic>.from(i as Map)).toJson()).toList();
      }
    } catch (_) {}
    return [];
  }
  Future<LobbyPageMetadata> fetchLobbyMetadata() async {
    try {
      final res = await executeFunction(
        projection: 'MobileLobbyHandling',
        functionName: 'GetMobileLobby()',
      );
      final val = res['value'];
      if (val is List && val.isNotEmpty) {
        final elements = <LobbyElementMetadata>[];
        for (final item in val) {
          try {
            if (item is Map) {
              elements.add(LobbyElementMetadata.fromJson(Map<String, dynamic>.from(item)));
            }
          } catch (e) {
            // Isolates single element failure so whole lobby is preserved
          }
        }
        if (elements.isNotEmpty) {
          return LobbyPageMetadata(
            pageId: 'lobby_main',
            title: 'Plant Performance',
            subtitle: 'Operational KPIs & Real-time Trends',
            elements: elements,
          );
        }
      }
    } catch (_) {}
    return AppMetadataService.defaultLobby;
  }

  Future<int> fetchEntityCount({
    required String projection,
    required String entitySet,
    String? filter,
  }) async {
    return _client.getCount(projection, entitySet, filter: filter);
  }
}
