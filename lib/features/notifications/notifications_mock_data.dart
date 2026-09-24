import 'package:flutter/material.dart';
import 'notifications_contract.dart';

abstract final class NotificationsMockData {
  static const initialNotifications = [
    // Today
    NotificationItem(
      id: 'notif-1',
      title: 'Shift schedule updated',
      message: 'Your upcoming shift roster for next week has been confirmed by operations.',
      time: '15m ago',
      group: NotificationTimeGroup.today,
      isRead: false,
      icon: Icons.calendar_today_rounded,
    ),
    NotificationItem(
      id: 'notif-2',
      title: 'Work order assigned (WO-8901)',
      message: 'You were assigned to Hydraulic Seal Replacement at Sector B.',
      time: '1h ago',
      group: NotificationTimeGroup.today,
      isRead: false,
      icon: Icons.assignment_late_outlined,
      workOrderId: 'wo-1',
    ),
    NotificationItem(
      id: 'notif-3',
      title: 'Work order scheduled (WO-8902)',
      message: 'Conveyor Motor Calibration is scheduled for today at 17:30.',
      time: '3h ago',
      group: NotificationTimeGroup.today,
      isRead: true,
      icon: Icons.assignment_turned_in_outlined,
      workOrderId: 'wo-2',
    ),

    // Yesterday
    NotificationItem(
      id: 'notif-4',
      title: 'System update completed',
      message: 'Scheduled cloud sync and client updates finished successfully with no disruption.',
      time: 'Yesterday, 4:30 PM',
      group: NotificationTimeGroup.yesterday,
      isRead: false,
      icon: Icons.sync_rounded,
    ),
    NotificationItem(
      id: 'notif-5',
      title: 'Purchase order sent',
      message: 'Purchase order #4102 has been received and processed by the vendor.',
      time: 'Yesterday, 11:15 AM',
      group: NotificationTimeGroup.yesterday,
      isRead: true,
      icon: Icons.receipt_long_outlined,
    ),

    // Older
    NotificationItem(
      id: 'notif-6',
      title: 'Password changed successfully',
      message: 'Your account password was updated from a recognized device.',
      time: '3 days ago',
      group: NotificationTimeGroup.older,
      isRead: true,
      icon: Icons.lock_outline_rounded,
    ),
    NotificationItem(
      id: 'notif-7',
      title: 'Monthly summary ready',
      message: 'Operational throughput and activity summary for last month is now available.',
      time: '5 days ago',
      group: NotificationTimeGroup.older,
      isRead: true,
      icon: Icons.insert_chart_outlined_rounded,
    ),
  ];
}
