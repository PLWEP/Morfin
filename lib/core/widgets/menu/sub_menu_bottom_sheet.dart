import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../navigation/action_dispatcher.dart';
import '../../services/navigator_service.dart';
import 'menu_item_tile.dart';

class SubMenuBottomSheet {
  const SubMenuBottomSheet._();

  static void show(
    BuildContext context, {
    required String title,
    required dynamic parentId,
  }) {
    final colors = AppColors.of(context);
    final items = NavigatorService.instance.getChildrenOfNode(parentId);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: colors.outline),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No actions available',
                      style: TextStyle(color: colors.outline, fontSize: 13),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return MenuItemTile(
                        item: item,
                        onTap: () {
                          Navigator.of(ctx).pop();
                          AppActionDispatcher.dispatch(context, item.action, fallbackTitle: item.title);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
