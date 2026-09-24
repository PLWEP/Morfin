import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../work_order_contract.dart';

class WorkOrderFilterChips extends StatelessWidget {
  final String selectedFilter;
  final List<WorkOrder> allItems;
  final ValueChanged<String> onFilterSelected;

  const WorkOrderFilterChips({
    super.key,
    required this.selectedFilter,
    required this.allItems,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final filters = [
      (key: 'all', label: 'All', count: allItems.length),
      (
        key: 'inProgress',
        label: 'In Progress',
        count: allItems.where((i) => i.status == WorkOrderStatus.inProgress).length,
      ),
      (
        key: 'pending',
        label: 'Pending',
        count: allItems.where((i) => i.status == WorkOrderStatus.pending).length,
      ),
      (
        key: 'completed',
        label: 'Completed',
        count: allItems.where((i) => i.status == WorkOrderStatus.completed).length,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter == f.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onFilterSelected(f.key),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.surfaceBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      f.label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : colors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.24)
                            : colors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${f.count}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
