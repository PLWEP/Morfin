import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../inventory/inventory_list_screen.dart';
import '../work_orders/work_order_list_screen.dart';
import 'components/menu_categorized_grid.dart';
import 'components/menu_filter_pills.dart';
import 'components/menu_search_bar.dart';
import 'menu_contract.dart';
import 'menu_provider.dart';

class MenuScreen extends ConsumerWidget {
  final VoidCallback? onAlertTap;

  const MenuScreen({super.key, this.onAlertTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuSearchBar(
                onQueryChanged: (query) {
                  notifier.dispatch(MenuSearchQueryChanged(query));
                },
              ),
              const SizedBox(height: 12),
              MenuFilterPills(
                selectedCategory: state.selectedCategory,
                onCategorySelected: (cat) {
                  notifier.dispatch(MenuCategoryChanged(cat));
                },
              ),
              const SizedBox(height: 16),
              MenuCategorizedGrid(
                modules: state.filteredModules,
                onModuleTap: (id) {
                  notifier.dispatch(MenuModuleSelected(id));
                  if (id == 'mod-1') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const WorkOrderListScreen(),
                      ),
                    );
                  } else if (id == 'mod-5') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const InventoryListScreen(),
                      ),
                    );
                  } else {
                    final module = state.modules.firstWhere((m) => m.id == id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${module.title} is coming soon'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
