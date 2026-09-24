import 'package:flutter/material.dart';
import 'notifications_contract.dart';
import 'notifications_mock_data.dart';

class NotificationsViewModel extends ValueNotifier<NotificationsState> {
  NotificationsViewModel()
      : super(const NotificationsState(
          items: NotificationsMockData.initialNotifications,
        ));

  void dispatch(NotificationsAction action) {
    switch (action) {
      case NotificationsFilterChanged(:final filter):
        value = value.copyWith(activeFilter: filter);

      case NotificationToggledRead(:final id):
        final updated = value.items.map((i) {
          if (i.id == id) return i.copyWith(isRead: !i.isRead);
          return i;
        }).toList();
        value = value.copyWith(items: updated);

      case NotificationDismissed(:final id):
        final updated = value.items.where((i) => i.id != id).toList();
        value = value.copyWith(items: updated);

      case NotificationsMarkAllRead():
        final updated =
            value.items.map((i) => i.copyWith(isRead: true)).toList();
        value = value.copyWith(items: updated);
    }
  }
}
