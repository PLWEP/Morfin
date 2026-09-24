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
      title: 'Safety inspection reminder',
      message: 'Routine inspection for Generator Unit 3 is scheduled today at 2:00 PM.',
      time: '1h ago',
      group: NotificationTimeGroup.today,
      isRead: false,
      icon: Icons.verified_user_outlined,
    ),
    NotificationItem(
      id: 'notif-3',
      title: 'Daily checklist approved',
      message: 'Supervisor signed off on the daily equipment pre-check documentation.',
      time: '3h ago',
      group: NotificationTimeGroup.today,
      isRead: true,
      icon: Icons.assignment_turned_in_outlined,
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
