import 'package:flutter/foundation.dart';

enum NotificationCategory {
  all,
  critical,
  workOrders,
  approvals,
  system,
}

enum NotificationPriority {
  critical,
  warning,
  success,
  neutral,
}

@immutable
class NotificationItem {
  final String id;
  final NotificationCategory category;
  final NotificationPriority priority;
  final String tag;
  final String timeAgo;
  final String title;
  final String description;
  final bool isRead;
  final String? sensorId;
  final String? price;
  final String? actionLabel;
  final double? progress;
  final String? progressLabel;

  const NotificationItem({
    required this.id,
    required this.category,
    required this.priority,
    required this.tag,
    required this.timeAgo,
    required this.title,
    required this.description,
    this.isRead = false,
    this.sensorId,
    this.price,
    this.actionLabel,
    this.progress,
    this.progressLabel,
  });

  NotificationItem copyWith({
    bool? isRead,
  }) {
    return NotificationItem(
      id: id,
      category: category,
      priority: priority,
      tag: tag,
      timeAgo: timeAgo,
      title: title,
      description: description,
      isRead: isRead ?? this.isRead,
      sensorId: sensorId,
      price: price,
      actionLabel: actionLabel,
      progress: progress,
      progressLabel: progressLabel,
    );
  }
}

@immutable
class NotificationsState {
  final List<NotificationItem> items;
  final NotificationCategory activeFilter;
  final bool isWsConnected;
  final String latencyText;
  final String shiftName;

  const NotificationsState({
    this.items = const [],
    this.activeFilter = NotificationCategory.all,
    this.isWsConnected = true,
    this.latencyText = 'Latency: 24ms • Sector 02-B',
    this.shiftName = 'Shift A • Escalating',
  });

  int get unreadCount => items.where((item) => !item.isRead).length;

  List<NotificationItem> get filteredItems {
    if (activeFilter == NotificationCategory.all) return items;
    return items.where((item) => item.category == activeFilter).toList();
  }

  NotificationsState copyWith({
    List<NotificationItem>? items,
    NotificationCategory? activeFilter,
    bool? isWsConnected,
    String? latencyText,
    String? shiftName,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      activeFilter: activeFilter ?? this.activeFilter,
      isWsConnected: isWsConnected ?? this.isWsConnected,
      latencyText: latencyText ?? this.latencyText,
      shiftName: shiftName ?? this.shiftName,
    );
  }
}

sealed class NotificationsAction {
  const NotificationsAction();
}

final class NotificationsFilterChanged extends NotificationsAction {
  final NotificationCategory filter;
  const NotificationsFilterChanged(this.filter);
}

final class NotificationDismissed extends NotificationsAction {
  final String id;
  const NotificationDismissed(this.id);
}

final class NotificationAcknowledged extends NotificationsAction {
  final String id;
  const NotificationAcknowledged(this.id);
}

final class NotificationApproved extends NotificationsAction {
  final String id;
  const NotificationApproved(this.id);
}

final class NotificationRejected extends NotificationsAction {
  final String id;
  const NotificationRejected(this.id);
}

final class NotificationsMarkAllRead extends NotificationsAction {
  const NotificationsMarkAllRead();
}
