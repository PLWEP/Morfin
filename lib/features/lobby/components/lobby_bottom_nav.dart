import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LobbyBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const LobbyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        border: Border(
          top: BorderSide(color: colors.surfaceBorder, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: colors.surfaceDeep,
        indicatorColor: colors.primary.withValues(alpha: 0.2),
        height: 62,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.dashboard_rounded, color: colors.statusActive, size: 22),
            label: 'Lobby',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.assignment_rounded, color: colors.statusActive, size: 22),
            label: 'Work Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.precision_manufacturing_rounded, color: colors.statusActive, size: 22),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.fact_check_rounded, color: colors.statusActive, size: 22),
            label: 'Approvals',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.more_horiz_rounded, color: colors.statusActive, size: 22),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
