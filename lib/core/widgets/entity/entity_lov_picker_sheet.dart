import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../network/odata_query.dart';
import '../../services/backend_service.dart';

class EntityLovPickerSheet extends StatefulWidget {
  final String title;
  final String projection;
  final String lovReference;
  final ValueChanged<String> onSelected;

  const EntityLovPickerSheet({
    super.key,
    required this.title,
    required this.projection,
    required this.lovReference,
    required this.onSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String projection,
    required String lovReference,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EntityLovPickerSheet(
        title: title,
        projection: projection,
        lovReference: lovReference,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<EntityLovPickerSheet> createState() => _EntityLovPickerSheetState();
}

class _EntityLovPickerSheetState extends State<EntityLovPickerSheet> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _fetchLovData();
  }

  Future<void> _fetchLovData() async {
    setState(() => _isLoading = true);
    final candidates = [
      'Reference_${widget.lovReference}',
      '${widget.lovReference}Set',
      widget.lovReference,
    ];

    for (final entitySet in candidates) {
      try {
        final res = await BackendService.instance.fetchEntitySet(
          projection: widget.projection,
          entitySet: entitySet,
          query: const ODataQuery(top: 50),
        );
        if (res.isNotEmpty && mounted) {
          setState(() {
            _items = res;
            _isLoading = false;
          });
          return;
        }
      } catch (_) {}
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _search.isEmpty
        ? _items
        : _items.where((r) => r.values.any((v) => v != null && v.toString().toLowerCase().contains(_search.toLowerCase()))).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: colors.surfaceBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: colors.outlineVariant, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Text(
            'Select ${widget.title}',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (val) => setState(() => _search = val),
            style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              filled: true,
              fillColor: colors.surfaceCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayed.isEmpty
                    ? Center(child: Text('No options available', style: TextStyle(color: colors.outline)))
                    : ListView.separated(
                        itemCount: displayed.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, index) {
                          final item = displayed[index];
                          final code = item.values.firstWhere((v) => v != null, orElse: () => '').toString();
                          final desc = item.length > 1 ? item.values.elementAt(1)?.toString() : null;
                          return ListTile(
                            title: Text(code, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: colors.onSurface)),
                            subtitle: desc != null ? Text(desc, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)) : null,
                            onTap: () {
                              widget.onSelected(code);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
