import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../inventory_contract.dart';
import '../inventory_view_model.dart';

class InventoryDetailSheet extends StatelessWidget {
  final String itemId;
  final InventoryViewModel viewModel;

  const InventoryDetailSheet({super.key, required this.itemId, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<InventoryState>(
      valueListenable: viewModel,
      builder: (context, state, _) {
        final item = viewModel.getItemById(itemId);
        if (item == null) {
          return const SizedBox.shrink();
        }

        final (statusColor, statusBg) = switch (item.status) {
          StockStatus.inStock => (colors.statusSuccess, colors.statusSuccess.withValues(alpha: 0.12)),
          StockStatus.lowStock => (colors.statusWarning, colors.statusWarning.withValues(alpha: 0.12)),
          StockStatus.outOfStock => (colors.statusCritical, colors.statusCritical.withValues(alpha: 0.12)),
        };

        return Container(
          decoration: BoxDecoration(
            color: colors.surfaceDeep,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: colors.surfaceBorder)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(item.code, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: colors.primary)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                        child: Text(item.status.label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: colors.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
              const SizedBox(height: 4),
              Text('${item.category} • ${item.binLocation}', style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Stock Level', style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('${item.quantity}', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: statusColor)),
                            const SizedBox(width: 4),
                            Text(item.unit, style: GoogleFonts.inter(fontSize: 14, color: colors.onSurfaceVariant)),
                          ],
                        ),
                        Text('Minimum threshold: ${item.minThreshold} ${item.unit}', style: GoogleFonts.inter(fontSize: 11, color: colors.outline)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: item.quantity > 0 ? () => viewModel.adjustStock(item.id, -1) : null,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () => viewModel.adjustStock(item.id, 1),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text('Logistics Metadata', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
              const SizedBox(height: 8),
              _buildMetaRow('Storage Aisle & Bin', item.binLocation, colors),
              _buildMetaRow('Restock Cycle', item.lastRestocked, colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetaRow(String label, String value, AppPalette colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurface)),
        ],
      ),
    );
  }
}
