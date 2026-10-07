import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/metadata/menu_metadata.dart';
import '../../core/services/navigator_service.dart';
import '../../core/widgets/menu/menu_item_tile.dart';
import '../../theme/app_colors.dart';
import 'components/menu_search_bar.dart';

class SubMenuScreen extends StatefulWidget {
  final dynamic parentId;
  final String title;

  const SubMenuScreen({
    super.key,
    required this.parentId,
    required this.title,
  });

  @override
  State<SubMenuScreen> createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  String _searchQuery = '';
  List<MenuItemMetadata> _items = const [];

  @override
  void initState() {
    super.initState();
    _items = NavigatorService.instance.getChildrenOfNode(widget.parentId);
  }

  List<MenuItemMetadata> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q) ||
          item.code.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _filteredItems;

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: colors.surfaceCard,
        surfaceTintColor: Colors.transparent,
      ),
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
              const SizedBox(height: 16),
              if (displayed.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No sub-modules found',
                      style: TextStyle(color: colors.outline, fontSize: 13),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayed.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => MenuItemTile(item: displayed[index]),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
