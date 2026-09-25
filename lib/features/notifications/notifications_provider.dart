import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifications_contract.dart';

class NotificationsNotifier extends Notifier<NotificationsState> {
  @override
  NotificationsState build() {
    return const NotificationsState(
      items: [],
    );
  }

  void dispatch(NotificationsAction action) {
    switch (action) {
      case NotificationsFilterChanged(:final filter):
        state = state.copyWith(activeFilter: filter);

      case NotificationToggledRead(:final id):
        final updated = state.items.map((i) {
          if (i.id == id) return i.copyWith(isRead: !i.isRead);
          return i;
        }).toList();
        state = state.copyWith(items: updated);

      case NotificationDismissed(:final id):
        final updated = state.items.where((i) => i.id != id).toList();
        state = state.copyWith(items: updated);

      case NotificationsMarkAllRead():
        final updated = state.items.map((i) => i.copyWith(isRead: true)).toList();
        state = state.copyWith(items: updated);
    }
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, NotificationsState>(
  NotificationsNotifier.new,
);
