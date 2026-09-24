import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../inventory_contract.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;

  const InventoryCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final (statusColor, statusBg) = switch (item.status) {
      StockStatus.inStock => (colors.statusSuccess, colors.statusSuccess.withValues(alpha: 0.12)),
      StockStatus.lowStock => (colors.statusWarning, colors.statusWarning.withValues(alpha: 0.12)),
      StockStatus.outOfStock => (colors.statusCritical, colors.statusCritical.withValues(alpha: 0.12)),
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
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant),
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
              item.name,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.shelves, size: 14, color: colors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  item.binLocation,
                  style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant),
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
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${item.quantity}',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: statusColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.unit,
                      style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                Text(
                  'Min: ${item.minThreshold} ${item.unit} • ${item.lastRestocked}',
                  style: GoogleFonts.inter(fontSize: 11, color: colors.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
