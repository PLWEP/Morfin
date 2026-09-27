import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/metadata/menu_metadata.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../theme/app_colors.dart';

class MenuFavoritesBar extends StatelessWidget {
  final List<MenuItemMetadata> items;
  final ValueChanged<MenuItemMetadata> onItemTap;

  const MenuFavoritesBar({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.star_rounded, size: 16, color: colors.statusWarning),
              const SizedBox(width: 6),
              Text(
                'PINNED & FAVORITES',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: colors.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final icon = IconResolver.resolve(item.icon, fallback: Icons.folder_outlined);

              return InkWell(
                onTap: () => onItemTap(item),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 18, color: colors.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
