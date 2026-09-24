import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'components/create_work_order_sheet.dart';
import 'components/work_order_card.dart';
import 'components/work_order_filter_chips.dart';
import 'components/work_order_search_bar.dart';
import 'work_order_contract.dart';
import 'work_order_detail_screen.dart';
import 'work_order_view_model.dart';

class WorkOrderListScreen extends StatefulWidget {
  final WorkOrderViewModel? viewModel;

  const WorkOrderListScreen({super.key, this.viewModel});

  @override
  State<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  late final WorkOrderViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? WorkOrderViewModel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (widget.viewModel == null) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateWorkOrderSheet(
        onCreated: ({
          required String title,
          required String assetName,
          required String location,
          required WorkOrderPriority priority,
          required String dueDate,
          required String description,
        }) {
          _viewModel.addWorkOrder(
            title: title,
            assetName: assetName,
            location: location,
            priority: priority,
            dueDate: dueDate,
            description: description,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Work order created successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateSheet,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Order', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
      appBar: AppBar(
        backgroundColor: colors.surfaceDeep,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Work Orders',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, size: 24, color: colors.onSurface),
            onPressed: _showCreateSheet,
          ),
        ],
      ),
      body: ValueListenableBuilder<WorkOrderState>(
        valueListenable: _viewModel,
        builder: (context, state, _) {
          final items = state.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: WorkOrderSearchBar(
                  controller: _searchController,
                  onChanged: _viewModel.setSearchQuery,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: WorkOrderFilterChips(
                  selectedFilter: state.selectedFilter,
                  allItems: state.items,
                  onFilterSelected: (filter) => _viewModel.setFilter(filter),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No work orders found',
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
                          return WorkOrderCard(
                            item: item,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WorkOrderDetailScreen(
                                    orderId: item.id,
                                    viewModel: _viewModel,
                                  ),
                                ),
                              );
                            },
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
