import 'package:flutter/foundation.dart';
import '../metadata/action_metadata.dart';
import '../metadata/menu_metadata.dart';
import '../metadata/metadata_service.dart';
import '../network/api_config.dart';
import 'erp_cloud_service.dart';

class NavigatorService {
  static final NavigatorService instance = NavigatorService._();
  NavigatorService._();

  MenuMetadata? _cachedMenu;

  MenuMetadata? get cachedMenu => _cachedMenu;

  void clearCache() => _cachedMenu = null;

  Future<MenuMetadata> fetchMenuMetadata({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedMenu != null) {
      return _cachedMenu!;
    }

    if (!ApiConfig.instance.isAuthenticated) {
      return AppMetadataService.defaultMenu;
    }

    try {
      final nodes = await ErpCloudService.instance.fetchNavigatorNodes();
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
    final validNodes = nodes.where((n) {
      final granted = n['EntryGranted'] != false;
      final hidden = n['Hidden'] == true;
      return granted && !hidden;
    }).toList();

    final childrenMap = <int, List<Map<String, dynamic>>>{};
    for (final node in validNodes) {
      final pid = node['ParentId'] as int? ?? 0;
      childrenMap.putIfAbsent(pid, () => []).add(node);
    }

    final rootNodes = childrenMap[0] ?? [];
    final groups = <MenuGroupMetadata>[];

    for (final root in rootNodes) {
      final rootId = root['Id'] as int? ?? 0;
      final rootLabel = (root['Label'] as String?)?.trim() ?? (root['Name'] as String?) ?? 'Module';
      final children = childrenMap[rootId] ?? [];
      if (children.isEmpty) continue;

      final items = <MenuItemMetadata>[];
      for (final child in children) {
        final childId = child['Id'] as int? ?? 0;
        final childLabel = (child['Label'] as String?)?.trim() ?? (child['Name'] as String?) ?? 'Item';
        final projection = child['Projection'] as String?;
        final client = child['Client'] as String?;
        final pageType = child['PageType'] as String?;
        final subChildrenCount = childrenMap[childId]?.length ?? 0;

        String? badgeText;
        String badgeType = 'none';

        if (pageType == '/Lobby') {
          badgeText = 'Lobby';
          badgeType = 'primary';
        } else if (subChildrenCount > 0) {
          badgeText = '$subChildrenCount pages';
          badgeType = 'info';
        } else if (projection != null && projection.isNotEmpty) {
          badgeText = 'Live';
          badgeType = 'active';
        }

        final target = projection ?? client ?? childLabel;

        items.add(
          MenuItemMetadata(
            id: childId.toString(),
            code: client ?? projection ?? 'NAV',
            title: childLabel,
            subtitle: projection != null ? 'Projection: $projection' : (client ?? 'Aurena Module'),
            icon: _resolveIcon(childLabel, projection),
            category: rootId.toString(),
            badgeText: badgeText,
            badgeType: badgeType,
            action: ActionMetadata(
              type: ActionType.navigate,
              target: target,
            ),
          ),
        );
      }

      if (items.isNotEmpty) {
        groups.add(
          MenuGroupMetadata(
            id: rootId.toString(),
            title: rootLabel,
            icon: _resolveIcon(rootLabel, null),
            items: items,
          ),
        );
      }
    }

    return MenuMetadata(version: 'live-ifs', groups: groups);
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
