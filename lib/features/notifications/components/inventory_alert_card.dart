import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';
import 'inventory_replenish_action.dart';
import 'inventory_stock_progress.dart';

class InventoryAlertCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onGeneratePO;

  const InventoryAlertCard({
    super.key,
    required this.item,
    this.onGeneratePO,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: colors.statusWarning,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.statusWarning.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_rounded,
                                    size: 11,
                                    color: colors.statusWarning,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.tag,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: colors.statusWarning,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.timeAgo,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                color: colors.outline,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Low Stock',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colors.statusWarning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InventoryStockProgress(
                      progress: item.progress ?? 0.32,
                      progressLabel: item.progressLabel,
                    ),
                    const SizedBox(height: 10),
                    InventoryReplenishAction(
                      onTap: onGeneratePO,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
