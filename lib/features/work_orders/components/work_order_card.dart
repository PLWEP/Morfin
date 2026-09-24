import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../work_order_contract.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrder item;
  final VoidCallback onTap;

  const WorkOrderCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final (statusColor, statusBg) = switch (item.status) {
      WorkOrderStatus.pending => (colors.statusWarning, colors.statusWarning.withValues(alpha: 0.12)),
      WorkOrderStatus.inProgress => (colors.primary, colors.primary.withValues(alpha: 0.12)),
      WorkOrderStatus.completed => (colors.statusSuccess, colors.statusSuccess.withValues(alpha: 0.12)),
    };

    final (priorityColor, priorityBg) = switch (item.priority) {
      WorkOrderPriority.urgent => (colors.statusCritical, colors.statusCritical.withValues(alpha: 0.12)),
      WorkOrderPriority.high => (colors.statusWarning, colors.statusWarning.withValues(alpha: 0.12)),
      WorkOrderPriority.medium => (colors.primary, colors.primary.withValues(alpha: 0.12)),
      WorkOrderPriority.low => (colors.onSurfaceVariant, colors.surfaceContainerHigh),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      item.code,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primary),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: priorityBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        item.priority.label,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: priorityColor),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.status.icon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        item.status.label,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.precision_manufacturing_outlined, size: 14, color: colors.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${item.assetName} • ${item.location}',
                    style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: colors.surfaceBorder),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: colors.surfaceContainerHigh,
                      child: Text(
                        item.assignedTo.isNotEmpty ? item.assignedTo[0] : 'U',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: colors.onSurface),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(item.assignedTo, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurface)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.checklist_rounded, size: 14, color: colors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${item.completedChecklistCount}/${item.checklist.length}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.schedule_rounded, size: 13, color: colors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(item.dueDate, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
