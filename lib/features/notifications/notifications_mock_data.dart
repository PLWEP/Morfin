import 'notifications_contract.dart';

abstract final class NotificationsMockData {
  static const initialNotifications = [
    NotificationItem(
      id: 'notif-1',
      category: NotificationCategory.critical,
      priority: NotificationPriority.critical,
      tag: 'CRITICAL #ALM-9942',
      timeAgo: '4m ago',
      title: 'Turbine Generator Alpha-3: Overheat Threshold',
      description:
          'Core temperature reached 114°C (Nominal ceiling: 95°C). Automatic throttling engaged on Sector 02-B substation bus.',
      sensorId: 'TG-A3-TH09 • Sector 02-B',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-2',
      category: NotificationCategory.approvals,
      priority: NotificationPriority.warning,
      tag: 'PR AUTHORIZATION #PR-3310',
      timeAgo: '28m ago',
      title: 'Hydraulic Pump Assembly Replacement',
      price: r'$18,400.00',
      description:
          'Supplier: Rexroth Bosch Industrial. Expedited turnaround for scheduled Sector 3 hydraulic overhaul.',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-3',
      category: NotificationCategory.workOrders,
      priority: NotificationPriority.success,
      tag: 'WO STATUS #WO-8940',
      timeAgo: '2h ago',
      title: 'Conveyor Line 4 Motor Calibration Completed',
      description:
          'Lead Tech M. Rodriguez verified stator clearance and closed package. Performance index logged at 98.4% nominal.',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-4',
      category: NotificationCategory.critical,
      priority: NotificationPriority.warning,
      tag: 'INVENTORY ALERT',
      timeAgo: '4h ago',
      title: 'Low Stock: Synthetic Lubricant ISO VG 220',
      description:
          'Available warehouse count: 12 Drums (Minimum threshold: 20 Drums). Located at BIN 4B-10.',
      progress: 0.32,
      progressLabel: 'Remaining: 20%',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-5',
      category: NotificationCategory.system,
      priority: NotificationPriority.neutral,
      tag: 'MAINTENANCE WINDOW',
      timeAgo: '1d ago',
      title: 'Database Telemetry Backup Synced to US-EAST-01',
      description:
          'All pending offline work packages and machine logs synchronized cleanly. Zero packet loss across 1,840 encrypted ledger frames.',
      isRead: true,
    ),
  ];
}
