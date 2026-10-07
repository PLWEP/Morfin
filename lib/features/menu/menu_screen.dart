import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/metadata/menu_metadata.dart';
import '../../core/navigation/action_dispatcher.dart';
import '../../core/providers/menu_provider.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/widgets/menu/menu_section_card.dart';
import '../../theme/app_colors.dart';
import 'components/menu_favorites_bar.dart';
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
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavorites());
  }

  void _loadFavorites() {
    final storage = ref.read(localStorageServiceProvider);
    setState(() => _favoriteIds = storage.getFavoriteMenuIds().toSet());
  }

  void _toggleFavorite(MenuItemMetadata item) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.toggleFavoriteMenuId(item.id);
    _loadFavorites();
  }

  List<MenuGroupMetadata> _filterGroups(MenuMetadata metadata) {
    return metadata.groups.map((group) {
      if (_selectedCategory != 'all' && group.id != _selectedCategory) {
        return MenuGroupMetadata(id: group.id, title: group.title, icon: group.icon, items: const []);
      }
      final q = _searchQuery.toLowerCase();
      final filteredItems = group.items.where((item) {
        if (_searchQuery.isEmpty) return true;
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
          loading: () => _buildLoading(colors),
          error: (err, _) => _buildError(colors, err.toString()),
          data: (metadata) => _buildContent(context, metadata),
        ),
      ),
    );
  }

  Widget _buildLoading(AppPalette colors) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: colors.primary),
            ),
            const SizedBox(height: 16),
            Text('Syncing Navigator...', style: TextStyle(color: colors.outline, fontSize: 13)),
          ],
        ),
      );

  Widget _buildError(AppPalette colors, String error) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 44, color: colors.statusCritical),
              const SizedBox(height: 12),
              Text('Failed to sync Navigator', style: TextStyle(color: colors.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(error, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: colors.outline, fontSize: 12)),
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

  Widget _buildContent(BuildContext context, MenuMetadata metadata) {
    final colors = AppColors.of(context);
    final displayedGroups = _filterGroups(metadata);
    final favoriteItems = metadata.allItems.where((i) => _favoriteIds.contains(i.id)).toList();

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surfaceCard,
      onRefresh: () => ref.read(menuProvider.notifier).refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuSearchBar(onQueryChanged: (q) => setState(() => _searchQuery = q)),
                const SizedBox(height: 12),
                if (favoriteItems.isNotEmpty && _searchQuery.isEmpty)
                  MenuFavoritesBar(
                    items: favoriteItems,
                    onItemTap: (i) => AppActionDispatcher.dispatch(context, i.action, fallbackTitle: i.title),
                  ),
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
                      child: Text('No matching modules found', style: TextStyle(color: colors.outline, fontSize: 13)),
                    ),
                  )
                else
                  ...displayedGroups.map((g) => MenuSectionCard(
                        group: g,
                        onItemTap: (i) => AppActionDispatcher.dispatch(context, i.action, fallbackTitle: i.title),
                        favoriteIds: _favoriteIds,
                        onToggleFavorite: _toggleFavorite,
                      )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
