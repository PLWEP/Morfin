import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/notification_card.dart';
import 'components/notifications_filter_pills.dart';
import 'components/notifications_header.dart';
import 'components/notifications_section_header.dart';
import 'notifications_contract.dart';
import 'notifications_view_model.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onAlertTap;
  final VoidCallback? onProfileTap;

  const NotificationsScreen({
    super.key,
    this.onAlertTap,
    this.onProfileTap,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationsViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: colors.outline,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'You are all caught up.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: colors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<NotificationsState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        final todayItems = state.todayItems;
        final yesterdayItems = state.yesterdayItems;
        final olderItems = state.olderItems;
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
                  onMarkAllRead: () =>
                      _viewModel.dispatch(const NotificationsMarkAllRead()),
                ),
                const SizedBox(height: 16),
                NotificationsFilterPills(
                  activeFilter: state.activeFilter,
                  totalCount: state.items.length,
                  unreadCount: state.unreadCount,
                  readCount: state.readCount,
                  onFilterSelected: (filter) =>
                      _viewModel.dispatch(NotificationsFilterChanged(filter)),
                ),
                const SizedBox(height: 8),
                if (!hasAny)
                  _buildEmptyState(colors, state.activeFilter)
                else ...[
                  if (todayItems.isNotEmpty) ...[
                    NotificationsSectionHeader(
                      title: 'Today',
                      count: todayItems.length,
                    ),
                    ...todayItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: NotificationCard(
                            item: item,
                            onTap: () => _viewModel.dispatch(
                              NotificationToggledRead(item.id),
                            ),
                          ),
                        )),
                  ],
                  if (yesterdayItems.isNotEmpty) ...[
                    NotificationsSectionHeader(
                      title: 'Yesterday',
                      count: yesterdayItems.length,
                    ),
                    ...yesterdayItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: NotificationCard(
                            item: item,
                            onTap: () => _viewModel.dispatch(
                              NotificationToggledRead(item.id),
                            ),
                          ),
                        )),
                  ],
                  if (olderItems.isNotEmpty) ...[
                    NotificationsSectionHeader(
                      title: 'Older',
                      count: olderItems.length,
                    ),
                    ...olderItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: NotificationCard(
                            item: item,
                            onTap: () => _viewModel.dispatch(
                              NotificationToggledRead(item.id),
                            ),
                          ),
                        )),
                  ],
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
