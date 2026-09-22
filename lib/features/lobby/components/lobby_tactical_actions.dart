import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class LobbyTacticalActions extends StatelessWidget {
  final ValueChanged<String> onActionTriggered;

  const LobbyTacticalActions({super.key, required this.onActionTriggered});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final actions = [
      {'id': 'scan_qr', 'icon': Icons.qr_code_scanner_rounded, 'label': 'Scan QR Barcode', 'color': colors.statusActive},
      {'id': 'create_wo', 'icon': Icons.add_task_rounded, 'label': 'Create Work Order', 'color': colors.statusActive},
      {'id': 'approve_pr', 'icon': Icons.task_alt_rounded, 'label': 'Quick PR Approval', 'color': colors.statusWarning},
      {'id': 'report_incident', 'icon': Icons.report_problem_outlined, 'label': 'Report Incident', 'color': colors.statusCritical},
      {'id': 'asset_lookup', 'icon': Icons.search_rounded, 'label': 'Asset Lookup', 'color': colors.primary},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TERMINAL DISPATCH',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Tactical Actions',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.statusActive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48, // 48dp touch target compliance
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final act = actions[i];
              return InkWell(
                onTap: () => onActionTriggered(act['id'] as String),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(act['icon'] as IconData, size: 18, color: act['color'] as Color),
                      const SizedBox(width: 8),
                      Text(
                        act['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
