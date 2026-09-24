import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../work_order_contract.dart';

class WorkOrderChecklistSection extends StatelessWidget {
  final WorkOrder order;
  final void Function(String orderId, String checklistId) onToggleItem;

  const WorkOrderChecklistSection({
    super.key,
    required this.order,
    required this.onToggleItem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Procedure Checklist',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            Text(
              '${order.completedChecklistCount}/${order.checklist.length} Completed',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...order.checklist.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onToggleItem(order.id, item.id),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: item.isDone ? colors.statusSuccess : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: item.isDone ? colors.onSurfaceVariant : colors.onSurface,
                          decoration: item.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
