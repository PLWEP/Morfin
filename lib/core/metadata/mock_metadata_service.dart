import 'lobby_metadata.dart';
import 'menu_metadata.dart';

class MockMetadataService {
  const MockMetadataService._();

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
                'badgeText': '6 Pending',
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
                'badgeText': '3 Low Stock',
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
                'badgeText': 'Operational',
                'badgeType': 'active',
                'action': {'type': 'navigate', 'target': '/lobby'}
              },
              {
                'id': 'scan_qr',
                'code': 'ASSET_SCAN',
                'title': 'Scan Equipment Tag',
                'subtitle': 'Quick Barcode/NFC lookup',
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
            'value': '6',
            'unit': 'jobs',
            'change': '+2 today',
            'isPositive': false,
            'benchmark': 'Target: < 5',
            'colorToken': 'warning',
            'span': {'col': 1, 'row': 1},
            'action': {'type': 'navigate', 'target': '/work_orders'}
          },
          {
            'id': 'elem_critical_spares',
            'type': 'counter',
            'title': 'Low Spares',
            'icon': 'inventory_2',
            'value': '3',
            'unit': 'items',
            'change': 'Restock needed',
            'isPositive': false,
            'benchmark': 'Threshold: 5',
            'colorToken': 'critical',
            'span': {'col': 1, 'row': 1},
            'action': {'type': 'navigate', 'target': '/inventory'}
          },
          {
            'id': 'elem_overall_oee',
            'type': 'indicator',
            'title': 'Plant OEE Performance',
            'icon': 'speed',
            'percentage': 89.2,
            'target': 85.0,
            'subtitle': 'Overall Equipment Effectiveness',
            'colorToken': 'success',
            'span': {'col': 2, 'row': 1},
            'action': {'type': 'navigate', 'target': '/lobby'}
          },
          {
            'id': 'elem_line_output',
            'type': 'bar_chart',
            'title': 'Output by Production Line (Units/h)',
            'icon': 'precision_manufacturing',
            'subtitle': 'Hourly telemetry',
            'colorToken': 'primary',
            'span': {'col': 2, 'row': 2},
            'chartPoints': [
              {'label': 'Line 1', 'value': 450},
              {'label': 'Line 2', 'value': 380},
              {'label': 'Line 3', 'value': 510},
              {'label': 'Line 4', 'value': 290}
            ],
            'action': {'type': 'navigate', 'target': '/lobby'}
          },
          {
            'id': 'elem_link_wo',
            'type': 'link_tile',
            'title': 'Open Maintenance Work Orders',
            'subtitle': 'View scheduled preventive and corrective tasks',
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
