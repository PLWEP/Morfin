import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/work_order_checklist_section.dart';
import 'components/work_order_detail_header.dart';
import 'work_order_contract.dart';
import 'work_order_provider.dart';

class WorkOrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const WorkOrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final notifier = ref.read(workOrderProvider.notifier);
    final order = ref.watch(workOrderProvider.select((s) {
      try {
        return s.items.firstWhere((o) => o.id == orderId);
      } catch (_) {
        return null;
      }
    }));

    if (order == null) {
      return Scaffold(
        backgroundColor: colors.surfaceDeep,
        appBar: AppBar(backgroundColor: colors.surfaceDeep),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceDeep,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          order.code,
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: colors.onSurface),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(order, notifier, colors),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkOrderDetailHeader(order: order),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              order.description,
              style: GoogleFonts.inter(fontSize: 14, height: 1.4, color: colors.onSurface),
            ),
            const SizedBox(height: 20),
            WorkOrderChecklistSection(
              order: order,
              onToggleItem: notifier.toggleChecklist,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(WorkOrder order, WorkOrderNotifier notifier, AppPalette colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(top: BorderSide(color: colors.surfaceBorder)),
      ),
      child: switch (order.status) {
        WorkOrderStatus.pending => ElevatedButton(
            onPressed: () => notifier.updateStatus(order.id, WorkOrderStatus.inProgress),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Start Work Order', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        WorkOrderStatus.inProgress => ElevatedButton(
            onPressed: () => notifier.updateStatus(order.id, WorkOrderStatus.completed),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.statusSuccess,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Mark as Completed', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        WorkOrderStatus.completed => Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 18, color: colors.statusSuccess),
                const SizedBox(width: 8),
                Text('Work Order Completed', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.statusSuccess)),
              ],
            ),
          ),
      },
    );
  }
}
