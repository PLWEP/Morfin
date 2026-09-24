import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../work_order_contract.dart';

class WorkOrderDetailHeader extends StatelessWidget {
  final WorkOrder order;

  const WorkOrderDetailHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${order.priority.label} Priority',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status.label,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.title,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            '${order.assetName} • ${order.location}',
            style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.surfaceBorder),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Assigned to: ${order.assignedTo}', style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
              Text('Due: ${order.dueDate}', style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}
