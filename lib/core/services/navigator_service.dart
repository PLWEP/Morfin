import 'package:flutter/foundation.dart';
import '../metadata/action_metadata.dart';
import '../metadata/menu_metadata.dart';
import '../network/api_config.dart';
import 'backend_service.dart';

class NavigatorService {
  static final NavigatorService instance = NavigatorService._();
  NavigatorService._();

  MenuMetadata? _cachedMenu;
  List<Map<String, dynamic>> _cachedNodes = [];
  Map<String, List<Map<String, dynamic>>> _childrenMap = {};

  MenuMetadata? get cachedMenu => _cachedMenu;
  List<Map<String, dynamic>> get cachedNodes => _cachedNodes;

  void clearCache() {
    _cachedMenu = null;
    _cachedNodes = [];
    _childrenMap.clear();
  }

  List<Map<String, dynamic>> getChildActions(String listNodeId) {
    return _cachedNodes.where((n) {
      final pid = (n['ParentId'] ?? '').toString();
      final act = (n['ActionType'] as String?)?.toUpperCase() ?? '';
      return pid == listNodeId && (act == 'ACTION' || act == 'FORM' || act.contains('FORM'));
    }).toList();
  }

  Future<MenuMetadata> fetchMenuMetadata({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedMenu != null) {
      return _cachedMenu!;
    }

    if (!ApiConfig.instance.isAuthenticated) {
      return const MenuMetadata(version: 'live', groups: []);
    }

    try {
      final nodes = await BackendService.instance.fetchNavigatorNodes();
      if (nodes.isEmpty) {
        return _cachedMenu ?? const MenuMetadata(version: 'live', groups: []);
      }

      final menu = _transformNodesToMenu(nodes);
      if (menu.groups.isNotEmpty) {
        _cachedMenu = menu;
        return menu;
      }
      return _cachedMenu ?? const MenuMetadata(version: 'live', groups: []);
    } catch (e) {
      debugPrint('NavigatorService.fetchMenuMetadata error: $e');
      if (_cachedMenu != null) return _cachedMenu!;
      rethrow;
    }
  }

  MenuMetadata _transformNodesToMenu(List<Map<String, dynamic>> nodes) {
    _cachedNodes = List<Map<String, dynamic>>.from(nodes);
    _childrenMap = {};
    for (final node in nodes) {
      final pid = (node['ParentId'] ?? '').toString();
      _childrenMap.putIfAbsent(pid, () => []).add(node);
    }

    final rootNodes = nodes.where((n) {
      final pid = n['ParentId'];
      final act = (n['ActionType'] as String?)?.toUpperCase();
      return pid == null || pid == '' || act == 'PARENT';
    }).toList();

    final groups = <MenuGroupMetadata>[];

    for (final root in rootNodes) {
      final rootId = (root['NodeId'] ?? root['Id'] ?? '').toString();
      final rootLabel = (root['Label'] ?? root['CleanLabel'] ?? 'Module').toString().trim();
      final items = getChildrenOfNode(rootId);

      if (items.isNotEmpty) {
        groups.add(
          MenuGroupMetadata(
            id: rootId,
            title: rootLabel,
            items: items,
          ),
        );
      }
    }

    return MenuMetadata(version: 'live', groups: groups);
  }

  List<MenuItemMetadata> getChildrenOfNode(dynamic parentId) {
    final key = (parentId ?? '').toString();
    final children = _childrenMap[key] ?? [];
    return children.map((child) {
      final childId = (child['NodeId'] ?? child['Id'] ?? '').toString();
      final childLabel = (child['Label'] ?? child['CleanLabel'] ?? 'Item').toString().trim();
      final targetUrl = child['TargetUrl'] as String?;
      final (parsedProj, parsedEndpoint) = _parseTargetUrl(targetUrl);
      final projection = child['TargetProjection'] as String? ?? parsedProj ?? child['Projection'] as String?;
      final entitySet = child['TargetEntitySet'] as String? ?? parsedEndpoint ?? child['EntitySet'] as String?;
      final actionType = (child['ActionType'] as String?)?.toUpperCase() ?? 'LIST';
      final defaultFilter = child['DefaultFilter'] as String?;
      final childCount = (child['ChildCount'] as num?)?.toInt() ?? 0;
      final isBottomSheet = actionType == 'BOTTOM_SHEET';
      final itemClickAction = (child['ItemClickAction'] ?? child['item_click_action']) as String?;
      final itemClickTarget = (child['ItemClickTarget'] ?? child['item_click_target']) as String?;
      final itemClickFields = (child['ItemClickFields'] ?? child['item_click_fields']) as String?;
      final columnConfig = (child['ColumnConfig'] ?? child['column_config']) as String?;
      final paramConfig = (child['ParamConfig'] ?? child['param_config']) as String?;

      final targetEndpoint = parsedEndpoint ?? child['TargetEndpoint'] as String?;
      final target = isBottomSheet
          ? '/bottom_sheet'
          : (projection != null ? '/$projection' : (targetEndpoint ?? childId));

      return MenuItemMetadata(
        id: childId,
        code: '',
        title: childLabel,
        subtitle: projection != null ? 'Projection: $projection' : 'Module',
        category: key,
        badgeText: actionType == 'FORM' ? 'Form' : null,
        badgeType: actionType == 'FORM' ? 'warning' : 'none',
        action: ActionMetadata(
          type: ActionType.navigate,
          target: target,
          params: {
            'nodeId': childId,
            'title': childLabel,
            'actionType': actionType,
            'targetUrl': targetUrl,
            'hasChildren': isBottomSheet || childCount > 0,
            'projection': projection,
            'targetProjection': projection,
            'entitySet': entitySet,
            'targetEndpoint': targetEndpoint,
            'defaultFilter': defaultFilter,
            'itemClickAction': itemClickAction,
            'itemClickTarget': itemClickTarget,
            'itemClickFields': itemClickFields,
            'columnConfig': columnConfig,
            'paramConfig': paramConfig,
          },
        ),
      );
    }).toList();
  }

  (String?, String?) _parseTargetUrl(String? targetUrl) {
    if (targetUrl == null || !targetUrl.contains('.svc/')) return (null, null);
    final parts = targetUrl.split('.svc/');
    final p = parts[0].replaceAll('/', '').trim();
    final e = parts[1].split('?')[0].replaceAll('/', '').trim();
    return (p.isNotEmpty ? p : null, e.isNotEmpty ? e : null);
  }

  @visibleForTesting
  MenuMetadata transformNodesForTesting(List<Map<String, dynamic>> nodes) => _transformNodesToMenu(nodes);

  @visibleForTesting
  (String?, String?) parseTargetUrlForTesting(String? url) => _parseTargetUrl(url);
}
