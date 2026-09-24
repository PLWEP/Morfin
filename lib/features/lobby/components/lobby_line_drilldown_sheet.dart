import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';

class LobbyLineDrilldownSheet extends StatelessWidget {
  final LinePerformance line;

  const LobbyLineDrilldownSheet({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final stations = [
      ('Feed In & Pre-Assembly', 0.98, 'Optimal'),
      ('Core Processing Unit', 0.94, 'Normal'),
      ('Automated Inspection Cell', 0.96, 'Optimal'),
      ('End of Line Packaging', line.efficiency, line.status),
    ];

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
              Text(line.lineName, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 20, color: colors.onSurfaceVariant),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Output Volume', style: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceVariant)),
                    Text(
                      '${(line.efficiency * 100).toStringAsFixed(1)}% Efficiency',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${line.outputUnits}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: colors.onSurface)),
                    Text(' / ${line.targetUnits} units', style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: line.efficiency.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: colors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Workstation Performance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface)),
          const SizedBox(height: 8),
          ...stations.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.$1, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.onSurface)),
                  Row(
                    children: [
                      Text('${(s.$2 * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.onSurface)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s.$3, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
