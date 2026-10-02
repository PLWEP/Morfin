import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../utils/record_display_utils.dart';
import '../../utils/record_lookup_loader.dart';
import 'record_lookup_tile.dart';

class RecordLookupSheet extends StatefulWidget {
  final String title;
  final String projection;
  final String lovReference;
  final String? contextFilter;
  final String? targetFieldKey;
  final Map<String, dynamic> contextualValues;
  final ValueChanged<String>? onSelected;
  final void Function(String code, String display)? onRecordSelected;

  const RecordLookupSheet({
    super.key,
    required this.title,
    required this.projection,
    required this.lovReference,
    this.contextFilter,
    this.targetFieldKey,
    this.contextualValues = const {},
    this.onSelected,
    this.onRecordSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String projection,
    required String lovReference,
    String? contextFilter,
    String? targetFieldKey,
    Map<String, dynamic> contextualValues = const {},
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
      targetFieldKey: targetFieldKey,
      contextualValues: contextualValues,
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
  String? _activeFilter;
  String? _debugInfo;

  @override
  void initState() {
    super.initState();
    _fetchLovData();
  }

  Future<void> _fetchLovData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _debugInfo = null;
    });

    final (items, filter, debug, err) = await RecordLookupLoader.load(
      projection: widget.projection,
      lovReference: widget.lovReference,
      contextFilter: widget.contextFilter,
      targetFieldKey: widget.targetFieldKey,
      contextualValues: widget.contextualValues,
    );

    if (mounted) {
      setState(() {
        _items = items;
        _activeFilter = filter;
        _debugInfo = debug;
        _errorMessage = err;
        _isLoading = false;
      });
    }
  }

  String _resolveCode(Map<String, dynamic> rawItem, List<(String, String)> rows) {
    if (widget.targetFieldKey != null && widget.targetFieldKey!.isNotEmpty) {
      final matchKey = rawItem.keys.firstWhere(
        (k) => k.toLowerCase() == widget.targetFieldKey!.toLowerCase(),
        orElse: () => '',
      );
      if (matchKey.isNotEmpty && rawItem[matchKey] != null) {
        return rawItem[matchKey].toString();
      }
    }
    return rows.isNotEmpty ? rows.first.$2 : '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _search.isEmpty
        ? _items
        : _items.where((r) {
            final filtered = Map.fromEntries(
              r.entries.where((e) => !RecordDisplayUtils.isMetadataKey(e.key)),
            );
            return filtered.values.any(
              (v) => v != null && v.toString().toLowerCase().contains(_search.toLowerCase()),
            );
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
            Text('Select ${widget.title}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
            const SizedBox(height: 6),
            _buildFilterBadge(colors),
            if (_debugInfo != null && _activeFilter == null) ...[
              const SizedBox(height: 4),
              Text(_debugInfo!, style: GoogleFonts.inter(fontSize: 9, color: colors.outline), textAlign: TextAlign.center),
            ],
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
            Expanded(child: _buildList(colors, displayed)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBadge(AppPalette colors) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _activeFilter != null ? colors.primary.withValues(alpha: 0.12) : colors.outlineVariant.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_activeFilter != null ? Icons.filter_alt_rounded : Icons.filter_alt_off_rounded, size: 13, color: _activeFilter != null ? colors.primary : colors.outline),
        const SizedBox(width: 4),
        Text(
          _activeFilter != null ? 'Filtered: $_activeFilter' : 'No Active Filter',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _activeFilter != null ? colors.primary : colors.outline),
        ),
      ],
    ),
  );

  Widget _buildList(AppPalette colors, List<Map<String, dynamic>> displayed) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return Center(child: Text(_errorMessage!, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)));
    if (displayed.isEmpty) return Center(child: Text('No options available', style: TextStyle(color: colors.outline)));

    return ListView.separated(
      itemCount: displayed.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final rawItem = displayed[index];
        final rows = RecordDisplayUtils.extractDisplayRows(rawItem);
        final code = _resolveCode(rawItem, rows);
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
    );
  }
}
