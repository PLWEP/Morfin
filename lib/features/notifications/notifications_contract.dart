import 'package:flutter/material.dart';

enum NotificationFilter {
  all,
  unread,
  read,
}

enum NotificationTimeGroup {
  today,
  yesterday,
  older,
}

@immutable
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationTimeGroup group;
  final bool isRead;
  final IconData? icon;
  final String? workOrderId;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.group,
    this.isRead = false,
    this.icon,
    this.workOrderId,
  });

  NotificationItem copyWith({
    bool? isRead,
    String? workOrderId,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      time: time,
      group: group,
      isRead: isRead ?? this.isRead,
      icon: icon,
      workOrderId: workOrderId ?? this.workOrderId,
    );
  }
}

@immutable
class NotificationsState {
  final List<NotificationItem> items;
  final NotificationFilter activeFilter;

  const NotificationsState({
    this.items = const [],
    this.activeFilter = NotificationFilter.all,
  });

  int get unreadCount => items.where((item) => !item.isRead).length;
  int get readCount => items.where((item) => item.isRead).length;

  List<NotificationItem> get filteredItems {
    return switch (activeFilter) {
      NotificationFilter.all => items,
      NotificationFilter.unread => items.where((i) => !i.isRead).toList(),
      NotificationFilter.read => items.where((i) => i.isRead).toList(),
    };
  }

  List<NotificationItem> get todayItems =>
      filteredItems.where((i) => i.group == NotificationTimeGroup.today).toList();

  List<NotificationItem> get yesterdayItems =>
      filteredItems.where((i) => i.group == NotificationTimeGroup.yesterday).toList();

  List<NotificationItem> get olderItems =>
      filteredItems.where((i) => i.group == NotificationTimeGroup.older).toList();

  NotificationsState copyWith({
    List<NotificationItem>? items,
    NotificationFilter? activeFilter,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

sealed class NotificationsAction {
  const NotificationsAction();
}

final class NotificationsFilterChanged extends NotificationsAction {
  final NotificationFilter filter;
  const NotificationsFilterChanged(this.filter);
}

final class NotificationToggledRead extends NotificationsAction {
  final String id;
  const NotificationToggledRead(this.id);
}

final class NotificationDismissed extends NotificationsAction {
  final String id;
  const NotificationDismissed(this.id);
}

final class NotificationsMarkAllRead extends NotificationsAction {
  const NotificationsMarkAllRead();
}
