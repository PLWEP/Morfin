import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../utils/record_display_utils.dart';
import 'record_lookup_tile.dart';

class RecordLookupSheet extends StatefulWidget {
  final String title;
  final String projection;
  final String lovReference;
  final String? contextFilter;
  final ValueChanged<String>? onSelected;
  final void Function(String code, String display)? onRecordSelected;

  const RecordLookupSheet({
    super.key,
    required this.title,
    required this.projection,
    required this.lovReference,
    this.contextFilter,
    this.onSelected,
    this.onRecordSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String projection,
    required String lovReference,
    String? contextFilter,
    ValueChanged<String>? onSelected,
    void Function(String code, String display)? onRecordSelected,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RecordLookupSheet(
      title: title,
      projection: projection,
      lovReference: lovReference,
      contextFilter: contextFilter,
      onSelected: onSelected,
      onRecordSelected: onRecordSelected,
    ),
  );

  @override
  State<RecordLookupSheet> createState() => _RecordLookupSheetState();
}

class _RecordLookupSheetState extends State<RecordLookupSheet> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String _search = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLovData();
  }

  Future<void> _fetchLovData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final proj = widget.projection.replaceAll('/', '').trim();
    if (proj.isEmpty) {
      if (mounted) setState(() { _isLoading = false; _errorMessage = 'Projection name is missing'; });
      return;
    }

    final ref = widget.lovReference.trim();
    if (ref.isEmpty) {
      if (mounted) setState(() { _isLoading = false; _errorMessage = 'LOV reference name is missing'; });
      return;
    }

    final entitySet = ref.startsWith('Reference_') ? ref : 'Reference_$ref';

    try {
      final res = await BackendService.instance.fetchEntitySet(
        projection: proj,
        entitySet: entitySet,
        query: DataQuery(
          top: 50,
          filter: (widget.contextFilter != null && widget.contextFilter!.trim().isNotEmpty)
              ? widget.contextFilter!.trim()
              : null,
        ),
      );
      if (mounted) {
        setState(() {
          _items = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _search.isEmpty
        ? _items
        : _items.where((r) {
            final filtered = Map.fromEntries(r.entries.where((e) => !RecordDisplayUtils.isMetadataKey(e.key)));
            return filtered.values.any((v) => v != null && v.toString().toLowerCase().contains(_search.toLowerCase()));
          }).toList();

    return Material(
      color: colors.surfaceDeep,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.surfaceBorder))),
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
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)))
                      : displayed.isEmpty
                          ? Center(child: Text('No options available', style: TextStyle(color: colors.outline)))
                          : ListView.separated(
                              itemCount: displayed.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (_, index) {
                                final rows = RecordDisplayUtils.extractDisplayRows(displayed[index]);
                                final code = rows.isNotEmpty ? rows.first.$2 : '';
                                final label = rows.length > 1 ? '${rows[0].$2} - ${rows[1].$2}' : code;
                                return RecordLookupTile(
                                  rows: rows,
                                  onTap: () {
                                    if (widget.onRecordSelected != null) {
                                      widget.onRecordSelected!(code, label);
                                    } else {
                                      widget.onSelected?.call(code);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
