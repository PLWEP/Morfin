import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_card.dart';

class RecordListContent extends StatelessWidget {
  final ScrollController scrollController;
  final EntitySchemaMetadata schema;
  final String? columnConfig;
  final List<Map<String, dynamic>> displayed;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool isSelectionMode;
  final Set<Map<String, dynamic>> selectedRecords;
  final ValueChanged<Map<String, dynamic>> onItemTap;
  final ValueChanged<Map<String, dynamic>> onItemLongPress;
  final ValueChanged<Map<String, dynamic>>? onDetailTap;
  final Future<void> Function() onRefresh;

  const RecordListContent({
    super.key,
    required this.scrollController,
    required this.schema,
    this.columnConfig,
    required this.displayed,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
    required this.isSelectionMode,
    required this.selectedRecords,
    required this.onItemTap,
    required this.onItemLongPress,
    this.onDetailTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (isLoading) return Center(child: CircularProgressIndicator(color: colors.primary));
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 36, color: colors.statusCritical),
            const SizedBox(height: 8),
            Text('Failed to sync live data', style: TextStyle(color: colors.onSurface)),
            TextButton(onPressed: onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (displayed.isEmpty) {
      return Center(child: Text('No records found', style: TextStyle(color: colors.outline)));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: colors.primary,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: displayed.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index >= displayed.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                ),
              ),
            );
          }
          final record = displayed[index];
          return RecordCard(
            schema: schema,
            record: record,
            columnConfig: columnConfig,
            isSelectionMode: isSelectionMode,
            isSelected: selectedRecords.contains(record),
            onTap: () => onItemTap(record),
            onLongPress: () => onItemLongPress(record),
            onDetailTap: onDetailTap != null ? () => onDetailTap!(record) : null,
          );
        },
      ),
    );
  }
}
