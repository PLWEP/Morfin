import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';

class NotificationsFilterPills extends StatelessWidget {
  final NotificationCategory activeFilter;
  final ValueChanged<NotificationCategory> onFilterSelected;

  const NotificationsFilterPills({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final filters = [
      (
        category: NotificationCategory.all,
        label: 'All',
        count: '18',
        icon: null as IconData?,
        dotColor: null as Color?,
      ),
      (
        category: NotificationCategory.critical,
        label: 'Critical',
        count: '3',
        icon: null,
        dotColor: colors.statusCritical,
      ),
      (
        category: NotificationCategory.workOrders,
        label: 'Work Orders',
        count: '8',
        icon: Icons.engineering_rounded,
        dotColor: null,
      ),
      (
        category: NotificationCategory.approvals,
        label: 'Approvals',
        count: '5',
        icon: Icons.verified_rounded,
        dotColor: null,
      ),
      (
        category: NotificationCategory.system,
        label: 'System',
        count: '2',
        icon: Icons.dns_rounded,
        dotColor: null,
      ),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = activeFilter == filter.category;

          return InkWell(
            onTap: () => onFilterSelected(filter.category),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? colors.primaryContainer : colors.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? colors.primaryContainer
                      : colors.surfaceBorder.withValues(alpha: 0.8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.dotColor != null) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: filter.dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ] else if (filter.icon != null) ...[
                    Icon(
                      filter.icon,
                      size: 13,
                      color: isSelected
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    filter.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.surfaceDeep.withValues(alpha: 0.35)
                          : colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      filter.count,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colors.primaryLight
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
