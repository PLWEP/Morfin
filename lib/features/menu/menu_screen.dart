import 'package:flutter/material.dart';
import '../../core/metadata/menu_metadata.dart';
import '../../core/metadata/metadata_service.dart';
import '../../core/widgets/menu/menu_section_card.dart';
import '../../theme/app_colors.dart';
import 'components/menu_filter_pills.dart';
import 'components/menu_search_bar.dart';

class MenuScreen extends StatefulWidget {
  final MenuMetadata? initialMetadata;
  final VoidCallback? onAlertTap;

  const MenuScreen({
    super.key,
    this.initialMetadata,
    this.onAlertTap,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late MenuMetadata _metadata;
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _metadata = widget.initialMetadata ?? AppMetadataService.defaultMenu;
  }

  List<MenuGroupMetadata> get _filteredGroups {
    return _metadata.groups.map((group) {
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
    final displayedGroups = _filteredGroups;

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
                onQueryChanged: (query) => setState(() => _searchQuery = query),
              ),
              const SizedBox(height: 12),
              MenuFilterPills(
                selectedCategory: _selectedCategory,
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
      ),
    );
  }
}
