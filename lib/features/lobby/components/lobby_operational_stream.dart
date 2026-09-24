import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../lobby_contract.dart';
import 'lobby_cycle_card.dart';
import 'lobby_pr_card.dart';
import 'lobby_turbine_card.dart';

class LobbyOperationalStream extends StatelessWidget {
  final List<OperationalFeed> feeds;

  const LobbyOperationalStream({super.key, required this.feeds});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.statusActive,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              '3 updates',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const LobbyTurbineCard(),
        const SizedBox(height: 10),
        const LobbyPrCard(),
        const SizedBox(height: 10),
        const LobbyCycleCard(),
      ],
    );
  }
}
