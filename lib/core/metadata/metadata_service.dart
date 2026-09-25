import 'lobby_metadata.dart';
import 'menu_metadata.dart';

class AppMetadataService {
  const AppMetadataService._();

  static MenuMetadata get defaultMenu => MenuMetadata.fromJson({
        'version': '1.0.0',
        'groups': [
          {
            'id': 'operations',
            'title': 'Operations & Maintenance',
            'icon': 'assignment',
            'items': [
              {
                'id': 'wo_exec',
                'code': 'WO_EXEC',
                'title': 'Work Orders',
                'subtitle': 'Execution & Maintenance Jobs',
                'icon': 'assignment',
                'category': 'operations',
                'badgeText': 'Live Sync',
                'badgeType': 'warning',
                'action': {'type': 'navigate', 'target': '/work_orders'}
              },
              {
                'id': 'inv_part',
                'code': 'INV_PART',
                'title': 'Part Inventory',
                'subtitle': 'Spares & Consumables',
                'icon': 'inventory_2',
                'category': 'operations',
                'badgeText': 'Live Sync',
                'badgeType': 'critical',
                'action': {'type': 'navigate', 'target': '/inventory'}
              }
            ]
          },
          {
            'id': 'equipment',
            'title': 'Plant Assets & Lines',
            'icon': 'precision_manufacturing',
            'items': [
              {
                'id': 'line_mon',
                'code': 'LINE_MON',
                'title': 'Production Lines',
                'subtitle': 'Telemetry & Active Status',
                'icon': 'precision_manufacturing',
                'category': 'equipment',
                'badgeText': 'Active',
                'badgeType': 'active',
                'action': {'type': 'navigate', 'target': '/lobby'}
              },
              {
                'id': 'scan_qr',
                'code': 'ASSET_SCAN',
                'title': 'Scan Equipment Tag',
                'subtitle': 'Barcode & NFC Scanner',
                'icon': 'qr_code_scanner',
                'category': 'equipment',
                'badgeType': 'hardware',
                'action': {'type': 'openDialog', 'target': 'QR Scanner'}
              }
            ]
          }
        ]
      });

  static LobbyPageMetadata get defaultLobby => LobbyPageMetadata.fromJson({
        'pageId': 'lobby_plant_overview',
        'title': 'Plant Performance',
        'subtitle': 'Real-time telemetry and equipment KPIs',
        'elements': [
          {
            'id': 'elem_active_wo',
            'type': 'counter',
            'title': 'Active Work Orders',
            'icon': 'assignment',
            'value': 'Live',
            'unit': 'jobs',
            'change': 'Tap to view',
            'isPositive': true,
            'benchmark': 'OData Projections',
            'colorToken': 'warning',
            'span': {'col': 1, 'row': 1},
            'action': {'type': 'navigate', 'target': '/work_orders'}
          },
          {
            'id': 'elem_critical_spares',
            'type': 'counter',
            'title': 'Warehouse Parts',
            'icon': 'inventory_2',
            'value': 'Live',
            'unit': 'items',
            'change': 'Tap to view',
            'isPositive': true,
            'benchmark': 'OData Projections',
            'colorToken': 'primary',
            'span': {'col': 1, 'row': 1},
            'action': {'type': 'navigate', 'target': '/inventory'}
          },
          {
            'id': 'elem_link_wo',
            'type': 'link_tile',
            'title': 'Open Work Orders',
            'subtitle': 'View scheduled preventive and corrective maintenance tasks',
            'icon': 'assignment',
            'colorToken': 'warning',
            'span': {'col': 2, 'row': 1},
            'action': {'type': 'navigate', 'target': '/work_orders'}
          },
          {
            'id': 'elem_link_inv',
            'type': 'link_tile',
            'title': 'Inspect Warehouse Spare Parts',
            'subtitle': 'Check bin locations and adjust inventory stocks',
            'icon': 'inventory_2',
            'colorToken': 'primary',
            'span': {'col': 2, 'row': 1},
            'action': {'type': 'navigate', 'target': '/inventory'}
          }
        ]
      });
}
