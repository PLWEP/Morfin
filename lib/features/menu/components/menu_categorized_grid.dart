import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../menu_contract.dart';
import 'module_list_tile.dart';

class MenuCategorizedGrid extends StatelessWidget {
  final List<ModuleItem> modules;
  final ValueChanged<String>? onModuleTap;

  const MenuCategorizedGrid({
    super.key,
    required this.modules,
    this.onModuleTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final categories = [
      (key: 'ops', title: 'Operations & Manufacturing', color: colors.statusActive),
      (key: 'supply', title: 'Supply Chain & Inventory', color: colors.statusWarning),
      (key: 'fin', title: 'Procurement & Finance', color: colors.statusWarning),
      (key: 'maint', title: 'Maintenance & Field Service', color: colors.statusSuccess),
      (key: 'workforce', title: 'Workforce & Shifts', color: colors.primary),
    ];

    return Column(
      children: categories.map((cat) {
        final catModules = modules.where((m) => m.category == cat.key).toList();
        if (catModules.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: cat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cat.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${catModules.length} NODES',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              ...catModules.map((module) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ModuleListTile(
                      module: module,
                      onTap: () => onModuleTap?.call(module.id),
                    ),
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}
