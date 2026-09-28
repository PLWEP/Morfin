import 'package:flutter/foundation.dart';
import '../metadata/action_metadata.dart';
import '../metadata/menu_metadata.dart';
import '../metadata/metadata_service.dart';
import '../network/api_config.dart';
import 'backend_service.dart';

class NavigatorService {
  static final NavigatorService instance = NavigatorService._();
  NavigatorService._();

  MenuMetadata? _cachedMenu;
  Map<String, List<Map<String, dynamic>>> _childrenMap = {};

  MenuMetadata? get cachedMenu => _cachedMenu;

  void clearCache() {
    _cachedMenu = null;
    _childrenMap.clear();
  }

  Future<MenuMetadata> fetchMenuMetadata({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedMenu != null) {
      return _cachedMenu!;
    }

    if (!ApiConfig.instance.isAuthenticated) {
      return AppMetadataService.defaultMenu;
    }

    try {
      final nodes = await BackendService.instance.fetchNavigatorNodes();
      if (nodes.isEmpty) {
        return _cachedMenu ?? AppMetadataService.defaultMenu;
      }

      final menu = _transformNodesToMenu(nodes);
      if (menu.groups.isNotEmpty) {
        _cachedMenu = menu;
        return menu;
      }
      return _cachedMenu ?? AppMetadataService.defaultMenu;
    } catch (e) {
      debugPrint('NavigatorService.fetchMenuMetadata error: $e');
      return _cachedMenu ?? AppMetadataService.defaultMenu;
    }
  }

  MenuMetadata _transformNodesToMenu(List<Map<String, dynamic>> nodes) {
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
      final rootIcon = root['Icon']?.toString();
      final items = getChildrenOfNode(rootId);

      if (items.isNotEmpty) {
        groups.add(
          MenuGroupMetadata(
            id: rootId,
            title: rootLabel,
            icon: rootIcon ?? _resolveIcon(rootLabel, null),
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
      final (parsedProj, parsedEntitySet) = _parseTargetUrl(targetUrl);
      final projection = child['TargetProjection'] as String? ?? parsedProj ?? child['Projection'] as String?;
      final entitySet = child['TargetEntitySet'] as String? ?? parsedEntitySet ?? child['EntitySet'] as String?;
      final actionType = (child['ActionType'] as String?)?.toUpperCase() ?? 'LIST';
      final icon = child['Icon'] as String?;
      final defaultFilter = child['DefaultFilter'] as String?;
      final childCount = (child['ChildCount'] as num?)?.toInt() ?? 0;
      final isBottomSheet = actionType == 'BOTTOM_SHEET';

      String? badgeText;
      String badgeType = 'none';

      if (isBottomSheet) {
        badgeText = childCount > 0 ? '$childCount items' : 'Menu';
        badgeType = 'info';
      } else if (actionType == 'FORM') {
        badgeText = 'Form';
        badgeType = 'warning';
      } else if (projection != null && projection.isNotEmpty) {
        badgeText = 'Live';
        badgeType = 'active';
      }

      final target = isBottomSheet ? '/bottom_sheet' : (projection ?? childId);

      return MenuItemMetadata(
        id: childId,
        code: '',
        title: childLabel,
        subtitle: projection != null ? 'Projection: $projection' : 'Module',
        icon: icon ?? _resolveIcon(childLabel, projection),
        category: key,
        badgeText: badgeText,
        badgeType: badgeType,
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
            'entitySet': entitySet,
            'defaultFilter': defaultFilter,
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

  String _resolveIcon(String label, String? projection) {
    final l = '$label ${projection ?? ''}'.toLowerCase();
    if (l.contains('maint') || l.contains('wo') || l.contains('order')) return 'assignment';
    if (l.contains('inv') || l.contains('part') || l.contains('supply') || l.contains('ware')) return 'inventory_2';
    if (l.contains('equip') || l.contains('plant') || l.contains('line') || l.contains('mx')) return 'precision_manufacturing';
    if (l.contains('report') || l.contains('analyt') || l.contains('stat')) return 'analytics';
    if (l.contains('person') || l.contains('hr') || l.contains('user') || l.contains('train')) return 'person';
    if (l.contains('config') || l.contains('admin') || l.contains('setup') || l.contains('sys')) return 'settings';
    if (l.contains('doc')) return 'folder';
    if (l.contains('lobby') || l.contains('dash')) return 'dashboard';
    return 'folder';
  }
}
