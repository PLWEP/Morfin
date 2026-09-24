import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';

class NotificationsFilterPills extends StatelessWidget {
  final NotificationFilter activeFilter;
  final int totalCount;
  final int unreadCount;
  final int readCount;
  final ValueChanged<NotificationFilter> onFilterSelected;

  const NotificationsFilterPills({
    super.key,
    required this.activeFilter,
    required this.totalCount,
    required this.unreadCount,
    required this.readCount,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final filters = [
      (filter: NotificationFilter.all, label: 'All', count: '$totalCount'),
      (filter: NotificationFilter.unread, label: 'Unread', count: '$unreadCount'),
      (filter: NotificationFilter.read, label: 'Read', count: '$readCount'),
    ];

    return Row(
      children: filters.map((item) {
        final isSelected = activeFilter == item.filter;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => onFilterSelected(item.filter),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryContainer
                    : colors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? colors.primary.withValues(alpha: 0.5)
                      : colors.surfaceBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primary.withValues(alpha: 0.25)
                          : colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.count,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colors.onPrimaryContainer
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
