import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../menu_contract.dart';
import 'quick_dispatch_card.dart';

class MenuQuickDispatch extends StatelessWidget {
  final List<QuickDispatchItem> items;
  final ValueChanged<String>? onItemTap;

  const MenuQuickDispatch({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: colors.statusActive,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Shortcuts',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return QuickDispatchCard(
                item: item,
                onTap: () => onItemTap?.call(item.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
