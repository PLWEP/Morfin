import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final items = const [
      _NavItem(icon: Icons.dashboard_rounded, label: 'Lobby'),
      _NavItem(icon: Icons.grid_view_rounded, label: 'Menu'),
      _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: colors.surfaceBorder.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = items[index];

              return Expanded(
                child: InkWell(
                  onTap: () => onDestinationSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primaryContainer.withValues(alpha: 0.28)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: colors.statusActive.withValues(
                                    alpha: 0.45,
                                  ),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            item.icon,
                            size: 21,
                            color: isSelected
                                ? colors.statusActive
                                : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? colors.onSurface
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}
