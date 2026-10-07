import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/metadata/menu_metadata.dart';
import '../../../theme/app_colors.dart';

class MenuFilterPills extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<MenuGroupMetadata> groups;

  const MenuFilterPills({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.groups = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final filters = <({String key, String label, bool hasIcon})>[
      (key: 'all', label: 'All', hasIcon: true),
      ...groups.map(
        (g) => (key: g.id, label: g.title, hasIcon: false),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedCategory == filter.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onCategorySelected(filter.key),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primaryContainer : colors.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colors.statusActive.withValues(alpha: 0.5)
                        : colors.surfaceBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter.hasIcon)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 14,
                          color: isSelected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.outlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Text(
                      filter.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
