import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/menu_metadata.dart';
import '../../utils/icon_resolver.dart';
import 'generic_menu_tile.dart';

class GenericMenuSection extends StatelessWidget {
  final MenuGroupMetadata group;
  final ValueChanged<MenuItemMetadata>? onItemTap;

  const GenericMenuSection({
    super.key,
    required this.group,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (group.items.isEmpty) return const SizedBox.shrink();

    final colors = AppColors.of(context);
    final iconData = group.icon != null ? IconResolver.resolve(group.icon) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              if (iconData != null) ...[
                Icon(iconData, size: 15, color: colors.outline),
                const SizedBox(width: 6),
              ],
              Text(
                group.title.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: colors.outline,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${group.items.length}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: group.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = group.items[index];
            return GenericMenuTile(
              item: item,
              onTap: onItemTap != null ? () => onItemTap!(item) : null,
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
