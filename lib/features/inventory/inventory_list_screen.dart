import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/inventory_card.dart';
import 'components/inventory_detail_sheet.dart';
import 'components/inventory_filter_chips.dart';
import 'inventory_contract.dart';
import 'inventory_view_model.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  late final InventoryViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = InventoryViewModel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _openDetailSheet(String itemId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InventoryDetailSheet(itemId: itemId, viewModel: _viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceDeep,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Warehouse Stock',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface),
        ),
      ),
      body: ValueListenableBuilder<InventoryState>(
        valueListenable: _viewModel,
        builder: (context, state, _) {
          final items = state.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.surfaceBorder),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _viewModel.setSearchQuery,
                    style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search SKU, item name, aisle...',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.onSurfaceVariant),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, size: 16, color: colors.onSurfaceVariant),
                              onPressed: () {
                                _searchController.clear();
                                _viewModel.setSearchQuery('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: InventoryFilterChips(
                  selectedFilter: state.selectedFilter,
                  allItems: state.items,
                  onFilterSelected: _viewModel.setFilter,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No inventory items found',
                          style: GoogleFonts.inter(fontSize: 14, color: colors.onSurfaceVariant),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return InventoryCard(
                            item: item,
                            onTap: () => _openDetailSheet(item.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
