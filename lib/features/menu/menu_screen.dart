import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/metadata/menu_metadata.dart';
import '../../core/providers/menu_provider.dart';
import '../../core/widgets/menu/menu_section_card.dart';
import '../../theme/app_colors.dart';
import 'components/menu_filter_pills.dart';
import 'components/menu_search_bar.dart';

class MenuScreen extends ConsumerStatefulWidget {
  final MenuMetadata? initialMetadata;

  const MenuScreen({super.key, this.initialMetadata});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  List<MenuGroupMetadata> _filterGroups(MenuMetadata metadata) {
    return metadata.groups.map((group) {
      if (_selectedCategory != 'all' && group.id != _selectedCategory) {
        return MenuGroupMetadata(id: group.id, title: group.title, icon: group.icon, items: const []);
      }

      final filteredItems = group.items.where((item) {
        if (_searchQuery.isEmpty) return true;
        final q = _searchQuery.toLowerCase();
        return item.title.toLowerCase().contains(q) ||
            item.subtitle.toLowerCase().contains(q) ||
            item.code.toLowerCase().contains(q);
      }).toList();

      return MenuGroupMetadata(
        id: group.id,
        title: group.title,
        icon: group.icon,
        items: filteredItems,
      );
    }).where((group) => group.items.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (widget.initialMetadata != null) {
      return _buildContent(context, widget.initialMetadata!);
    }

    final menuAsync = ref.watch(menuProvider);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      body: SafeArea(
        child: menuAsync.when(
          loading: () => _buildLoadingState(colors),
          error: (error, _) => _buildErrorState(colors, error.toString()),
          data: (metadata) => _buildContent(context, metadata),
        ),
      ),
    );
  }

  Widget _buildLoadingState(AppPalette colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: colors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Syncing IFS Navigator...',
            style: TextStyle(color: colors.outline, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppPalette colors, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 44, color: colors.statusCritical),
            const SizedBox(height: 12),
            Text(
              'Failed to sync Navigator',
              style: TextStyle(color: colors.onSurface, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.outline, fontSize: 12),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => ref.read(menuProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MenuMetadata metadata) {
    final colors = AppColors.of(context);
    final displayedGroups = _filterGroups(metadata);

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surfaceCard,
      onRefresh: () async {
        await ref.read(menuProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuSearchBar(
              onQueryChanged: (query) => setState(() => _searchQuery = query),
            ),
            const SizedBox(height: 12),
            MenuFilterPills(
              selectedCategory: _selectedCategory,
              groups: metadata.groups,
              onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 16),
            if (displayedGroups.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No matching modules found',
                    style: TextStyle(color: colors.outline, fontSize: 13),
                  ),
                ),
              )
            else
              ...displayedGroups.map((group) => MenuSectionCard(group: group)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
