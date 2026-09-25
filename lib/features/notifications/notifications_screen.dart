import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/metadata/action_metadata.dart';
import '../../core/navigation/action_dispatcher.dart';
import '../../theme/app_colors.dart';
import 'components/notification_card.dart';
import 'components/notifications_filter_pills.dart';
import 'components/notifications_header.dart';
import 'components/notifications_section_header.dart';
import 'notifications_contract.dart';
import 'notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  final VoidCallback? onAlertTap;
  final VoidCallback? onProfileTap;

  const NotificationsScreen({super.key, this.onAlertTap, this.onProfileTap});

  void _handleTap(BuildContext context, WidgetRef ref, NotificationItem item) {
    if (!item.isRead) {
      ref.read(notificationsProvider.notifier).dispatch(NotificationToggledRead(item.id));
    }
    if (item.targetRoute != null) {
      AppActionDispatcher.dispatch(
        context,
        ActionMetadata(type: ActionType.navigate, target: item.targetRoute!),
      );
    }
  }

  Widget _buildEmptyState(AppPalette colors, NotificationFilter filter) {
    final message = switch (filter) {
      NotificationFilter.unread => 'No unread notifications',
      NotificationFilter.read => 'No read notifications',
      NotificationFilter.all => 'No notifications yet',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: colors.surfaceContainer, shape: BoxShape.circle),
              child: Icon(Icons.notifications_none_rounded, size: 28, color: colors.onSurfaceMuted),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              'Activity alerts and tasks will appear here.',
              style: GoogleFonts.inter(fontSize: 13, color: colors.outline),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final state = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    final sections = [
      ('Today', state.todayItems),
      ('Yesterday', state.yesterdayItems),
      ('Older', state.olderItems),
    ];
    final hasAny = state.filteredItems.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          physics: const BouncingScrollPhysics(),
          children: [
            NotificationsHeader(
              unreadCount: state.unreadCount,
              onMarkAllRead: () => notifier.dispatch(const NotificationsMarkAllRead()),
            ),
            const SizedBox(height: 16),
            NotificationsFilterPills(
              activeFilter: state.activeFilter,
              totalCount: state.items.length,
              unreadCount: state.unreadCount,
              readCount: state.readCount,
              onFilterSelected: (filter) => notifier.dispatch(NotificationsFilterChanged(filter)),
            ),
            const SizedBox(height: 8),
            if (!hasAny)
              _buildEmptyState(colors, state.activeFilter)
            else
              for (final (title, items) in sections)
                if (items.isNotEmpty) ...[
                  NotificationsSectionHeader(title: title, count: items.length),
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NotificationCard(
                        item: item,
                        onTap: () => _handleTap(context, ref, item),
                      ),
                    ),
                  ),
                ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
