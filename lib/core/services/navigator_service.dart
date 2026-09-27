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
  Map<int, List<Map<String, dynamic>>> _childrenMap = {};

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
      final pid = (node['ParentId'] as num?)?.toInt() ?? 0;
      _childrenMap.putIfAbsent(pid, () => []).add(node);
    }

    final rootNodes = _childrenMap[0] ?? [];
    final groups = <MenuGroupMetadata>[];

    for (final root in rootNodes) {
      final rootId = (root['Id'] as num?)?.toInt() ?? 0;
      final rootLabel = (root['CleanLabel'] as String?)?.trim() ??
          (root['Label'] as String?)?.trim() ??
          (root['Name'] as String?) ??
          'Module';
      final rootIcon = root['Icon'] as String?;
      final items = getChildrenOfNode(rootId);

      if (items.isNotEmpty) {
        groups.add(
          MenuGroupMetadata(
            id: rootId.toString(),
            title: rootLabel,
            icon: rootIcon ?? _resolveIcon(rootLabel, null),
            items: items,
          ),
        );
      }
    }

    return MenuMetadata(version: 'live', groups: groups);
  }

  Future<List<MenuItemMetadata>> fetchChildrenOfNode(int parentId) async {
    if (_childrenMap.containsKey(parentId) && _childrenMap[parentId]!.isNotEmpty) {
      return getChildrenOfNode(parentId);
    }
    try {
      final children = await BackendService.instance.fetchNavigatorNodes(parentId: parentId);
      if (children.isNotEmpty) {
        _childrenMap[parentId] = children;
      }
      return getChildrenOfNode(parentId);
    } catch (e) {
      debugPrint('NavigatorService.fetchChildrenOfNode error: $e');
      return getChildrenOfNode(parentId);
    }
  }

  List<MenuItemMetadata> getChildrenOfNode(int parentId) {
    final children = _childrenMap[parentId] ?? [];
    return children.map((child) {
      final childId = (child['Id'] as num?)?.toInt() ?? 0;
      final childLabel = (child['CleanLabel'] as String?)?.trim() ??
          (child['Label'] as String?)?.trim() ??
          (child['Name'] as String?) ??
          'Item';
      final projection = child['Projection'] as String?;
      final entitySet = child['EntitySet'] as String?;
      final client = child['Client'] as String?;
      final pageType = child['PageType'] as String?;
      final entryType = (child['EntryType'] as String?)?.toUpperCase();
      final icon = child['Icon'] as String?;
      final subChildrenCount = _childrenMap[childId]?.length ?? 0;
      final isMenu = entryType == 'MENU' || subChildrenCount > 0;
      final isLobby = entryType == 'LOBBY' || pageType == '/Lobby';

      String? badgeText;
      String badgeType = 'none';

      if (isLobby) {
        badgeText = 'Lobby';
        badgeType = 'primary';
      } else if (subChildrenCount > 0) {
        badgeText = '$subChildrenCount pages';
        badgeType = 'info';
      } else if (isMenu) {
        badgeText = 'Menu';
        badgeType = 'info';
      } else if (projection != null && projection.isNotEmpty) {
        badgeText = 'Live';
        badgeType = 'active';
      }

      final target = isLobby
          ? '/lobby'
          : (isMenu ? '/submenu' : (projection ?? client ?? childLabel));

      return MenuItemMetadata(
        id: childId.toString(),
        code: (client != null && client.length <= 6 && !client.contains(' ')) ? client : '',
        title: childLabel,
        subtitle: projection != null ? 'Projection: $projection' : (client ?? 'Module'),
        icon: icon ?? _resolveIcon(childLabel, projection),
        category: parentId.toString(),
        badgeText: badgeText,
        badgeType: badgeType,
        action: ActionMetadata(
          type: ActionType.navigate,
          target: target,
          params: {
            'nodeId': childId,
            'title': childLabel,
            'hasChildren': isMenu,
            'projection': projection,
            'entitySet': entitySet,
            'client': client,
          },
        ),
      );
    }).toList();
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
