import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class RecordArrayItemTile extends StatelessWidget {
  final int index;
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecordArrayItemTile({
    super.key,
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final validEntries = item.entries.where((e) => e.value != null && e.value.toString().isNotEmpty).toList();
    final primary = validEntries.isNotEmpty ? validEntries.first.value.toString() : 'Item #${index + 1}';
    final subtitle = validEntries.skip(1).take(3).map((e) => '${e.key}: ${e.value}').join(' • ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${index + 1}',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.outline),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primary.toString(),
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface),
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: colors.outline)),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16),
            color: colors.outline,
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            color: colors.statusCritical,
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
