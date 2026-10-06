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
        'subtitle': 'Operational KPIs & Real-time Trends',
        'elements': [
          {
            'id': 'elem_released_pr',
            'type': 'counter',
            'title': 'Released PRs',
            'subtitle': 'Lines awaiting PO',
            'icon': 'assignment',
            'value': 'Live',
            'unit': 'lines',
            'change': 'Tap to view',
            'isPositive': true,
            'benchmark': 'Live Cloud Metrics',
            'colorToken': 'warning',
            'span': {'col': 1, 'row': 1},
            'targetProjection': 'MorfinApiHandling',
            'targetEndpoint': 'ReleasedPurchaseReqLineSet',
            'filterConditions': "Objstate eq 'Released'",
            'action': {
              'type': 'navigate',
              'target': '/record_list',
              'params': {
                'projection': 'MorfinApiHandling',
                'endpoint': 'ReleasedPurchaseReqLineSet',
                'filter': "Objstate eq 'Released'",
                'title': 'Released PRs',
              }
            }
          },
          {
            'id': 'elem_budget_indicator',
            'type': 'indicator',
            'title': 'Budget Compliance',
            'subtitle': 'PR spend vs monthly limit',
            'icon': 'pie_chart_outline',
            'percentage': 84.5,
            'target': 90.0,
            'colorToken': 'success',
            'span': {'col': 1, 'row': 1},
            'action': {'type': 'navigate', 'target': '/work_orders'}
          },
          {
            'id': 'elem_po_bar_chart',
            'type': 'barchart',
            'title': 'Monthly PO Volume',
            'subtitle': 'Recent 5 months volume (units)',
            'icon': 'bar_chart_rounded',
            'colorToken': 'primary',
            'span': {'col': 2, 'row': 1},
            'chartPoints': [
              {'label': 'May', 'value': 45},
              {'label': 'Jun', 'value': 72},
              {'label': 'Jul', 'value': 58},
              {'label': 'Aug', 'value': 89},
              {'label': 'Sep', 'value': 110},
            ],
            'action': {'type': 'navigate', 'target': '/work_orders'}
          },
          {
            'id': 'elem_pr_line_chart',
            'type': 'linechart',
            'title': 'Requisition Flow Trend',
            'subtitle': 'Daily requisition throughput',
            'icon': 'show_chart_rounded',
            'colorToken': 'accent',
            'span': {'col': 2, 'row': 1},
            'chartPoints': [
              {'label': 'Mon', 'value': 12},
              {'label': 'Tue', 'value': 18},
              {'label': 'Wed', 'value': 15},
              {'label': 'Thu', 'value': 24},
              {'label': 'Fri', 'value': 28},
              {'label': 'Sat', 'value': 22},
              {'label': 'Sun', 'value': 35},
            ],
            'action': {'type': 'navigate', 'target': '/work_orders'}
          }
        ]
      });
}
