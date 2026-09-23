import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'components/approval_request_card.dart';
import 'components/critical_overheat_card.dart';
import 'components/inventory_alert_card.dart';
import 'components/notifications_filter_pills.dart';
import 'components/notifications_header.dart';
import 'components/notifications_section_header.dart';
import 'components/notifications_telemetry_ribbon.dart';
import 'components/system_sync_card.dart';
import 'components/work_order_notification_card.dart';
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

  Widget _buildCard(NotificationItem item) {
    return switch (item.id) {
      'notif-1' => CriticalOverheatCard(
          item: item,
          onAcknowledge: () =>
              _viewModel.dispatch(NotificationAcknowledged(item.id)),
          onDismiss: () =>
              _viewModel.dispatch(NotificationDismissed(item.id)),
        ),
      'notif-2' => ApprovalRequestCard(
          item: item,
          onApprove: () =>
              _viewModel.dispatch(NotificationApproved(item.id)),
          onReject: () =>
              _viewModel.dispatch(NotificationRejected(item.id)),
        ),
      'notif-3' => WorkOrderNotificationCard(item: item),
      'notif-4' => InventoryAlertCard(item: item),
      _ => SystemSyncCard(item: item),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<NotificationsState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        final items = state.filteredItems;
        final todayItems =
            items.where((i) => i.id == 'notif-1' || i.id == 'notif-2').toList();
        final earlierItems =
            items.where((i) => i.id == 'notif-3' || i.id == 'notif-4').toList();
        final yesterdayItems =
            items.where((i) => i.id == 'notif-5').toList();

        return Scaffold(
          backgroundColor: colors.surfaceDeep,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              NotificationsHeader(
                unreadCount: state.unreadCount,
                onClearAll: () =>
                    _viewModel.dispatch(const NotificationsMarkAllRead()),
                onTuneFilter: () {},
              ),
              const SizedBox(height: 12),
              NotificationsTelemetryRibbon(
                latencyText: state.latencyText,
                shiftName: state.shiftName,
                isWsConnected: state.isWsConnected,
              ),
              const SizedBox(height: 14),
              NotificationsFilterPills(
                activeFilter: state.activeFilter,
                onFilterSelected: (filter) =>
                    _viewModel.dispatch(NotificationsFilterChanged(filter)),
              ),
              const SizedBox(height: 16),
              if (todayItems.isNotEmpty) ...[
                NotificationsSectionHeader(
                  title: 'Today • Critical & High Priority',
                  icon: Icons.crisis_alert_rounded,
                  iconColor: colors.statusCritical,
                  badgeText: '${todayItems.length} PENDING ACTION',
                  badgeColor: colors.statusCritical,
                ),
                const SizedBox(height: 8),
                ...todayItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCard(item),
                    )),
              ],
              if (earlierItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                NotificationsSectionHeader(
                  title: 'Earlier Today',
                  icon: Icons.schedule_rounded,
                  iconColor: colors.statusActive,
                  badgeText: 'UPDATED 12M AGO',
                  badgeColor: colors.outline,
                ),
                const SizedBox(height: 8),
                ...earlierItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCard(item),
                    )),
              ],
              if (yesterdayItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                NotificationsSectionHeader(
                  title: 'Yesterday',
                  icon: Icons.history_rounded,
                  iconColor: colors.outline,
                  badgeText: 'ALL READ',
                  badgeColor: colors.outline,
                ),
                const SizedBox(height: 8),
                ...yesterdayItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCard(item),
                    )),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
    );
  }
}
