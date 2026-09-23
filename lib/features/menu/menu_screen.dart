import 'package:flutter/material.dart';
import '../../core/widgets/industrial_top_app_bar.dart';
import '../../theme/app_colors.dart';
import 'components/menu_categorized_grid.dart';
import 'components/menu_filter_pills.dart';
import 'components/menu_offline_diagnostics_card.dart';
import 'components/menu_plant_telemetry_banner.dart';
import 'components/menu_quick_dispatch.dart';
import 'components/menu_search_bar.dart';
import 'menu_contract.dart';
import 'menu_view_model.dart';

class MenuScreen extends StatefulWidget {
  final VoidCallback? onAlertTap;

  const MenuScreen({super.key, this.onAlertTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final MenuViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MenuViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<MenuState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: colors.surfaceDeep,
          appBar: IndustrialTopAppBar(
            title: 'Menu',
            onAlertTap: widget.onAlertTap,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuSearchBar(
                  onQueryChanged: (query) {
                    _viewModel.dispatch(MenuSearchQueryChanged(query));
                  },
                ),
                const SizedBox(height: 12),
                MenuFilterPills(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (cat) {
                    _viewModel.dispatch(MenuCategoryChanged(cat));
                  },
                ),
                const SizedBox(height: 18),
                MenuQuickDispatch(
                  items: state.quickDispatches,
                  onItemTap: (id) {
                    _viewModel.dispatch(MenuModuleSelected(id));
                  },
                ),
                const SizedBox(height: 18),
                const MenuPlantTelemetryBanner(),
                const SizedBox(height: 20),
                MenuCategorizedGrid(
                  modules: state.filteredModules,
                  onModuleTap: (id) {
                    _viewModel.dispatch(MenuModuleSelected(id));
                  },
                ),
                const SizedBox(height: 12),
                const MenuOfflineDiagnosticsCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
