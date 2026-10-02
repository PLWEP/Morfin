import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../services/schema_catalog_service.dart';
import '../../utils/record_display_utils.dart';
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

    final proj = widget.projection.replaceAll('/', '').trim();
    if (proj.isEmpty) {
      if (mounted)
        setState(() {
          _isLoading = false;
          _errorMessage = 'Projection name is missing';
        });
      return;
    }

    final ref = widget.lovReference.trim();
    if (ref.isEmpty) {
      if (mounted)
        setState(() {
          _isLoading = false;
          _errorMessage = 'LOV reference name is missing';
        });
      return;
    }

    final entitySet = ref.startsWith('Reference_') ? ref : 'Reference_$ref';

    try {
      // 1. Determine effective filter: explicit contextFilter or dynamically resolved from entity keys
      String? effectiveFilter =
          (widget.contextFilter != null &&
              widget.contextFilter!.trim().isNotEmpty)
          ? widget.contextFilter!.trim()
          : null;

      String debugNotes =
          'proj:$proj|set:$entitySet|target:${widget.targetFieldKey}';

      // 2. Metadata-driven key filtering (SDUI):
      // If no explicit filter is given and contextual values exist, inspect entity keys
      if (effectiveFilter == null &&
          widget.contextualValues.isNotEmpty &&
          widget.targetFieldKey != null &&
          widget.targetFieldKey!.isNotEmpty) {
        final entityKeys = await SchemaCatalogService.instance.fetchEntityKeys(
          projection: proj,
          entitySetOrName: entitySet,
        );

        final targetLower = widget.targetFieldKey!.toLowerCase();
        final dynamicParts = <String>[];

        for (final k in entityKeys) {
          if (k.toLowerCase() == targetLower) continue;

          // Direct match by entity key name from context
          final match = widget.contextualValues.entries.firstWhere(
            (e) =>
                e.key.toLowerCase() == k.toLowerCase() &&
                e.value != null &&
                e.value.toString().isNotEmpty,
            orElse: () => const MapEntry('', null),
          );

          if (match.key.isNotEmpty) {
            dynamicParts.add("$k eq '${match.value}'");
          }
        }

        if (dynamicParts.isNotEmpty) {
          effectiveFilter = dynamicParts.join(' and ');
        }
        debugNotes +=
            '|keys:${entityKeys.join(",")}|ctx:${widget.contextualValues.keys.join(",")}';
      } else {
        debugNotes +=
            '|ctxEmpty:${widget.contextualValues.isEmpty}|ctx:${widget.contextualValues}';
      }

      final res = await BackendService.instance.fetchEntitySet(
        projection: proj,
        entitySet: entitySet,
        query: DataQuery(top: 50, filter: effectiveFilter),
      );
      if (mounted) {
        setState(() {
          _items = res;
          _activeFilter = effectiveFilter;
          _debugInfo = debugNotes;
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
            final filtered = Map.fromEntries(
              r.entries.where((e) => !RecordDisplayUtils.isMetadataKey(e.key)),
            );
            return filtered.values.any(
              (v) =>
                  v != null &&
                  v.toString().toLowerCase().contains(_search.toLowerCase()),
            );
          }).toList();

    return Material(
      color: colors.surfaceDeep,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.surfaceBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Select ${widget.title}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _activeFilter != null
                    ? colors.primary.withValues(alpha: 0.12)
                    : colors.outlineVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _activeFilter != null
                        ? Icons.filter_alt_rounded
                        : Icons.filter_alt_off_rounded,
                    size: 13,
                    color: _activeFilter != null
                        ? colors.primary
                        : colors.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _activeFilter != null
                        ? 'Filtered: $_activeFilter'
                        : 'No Active Filter',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _activeFilter != null
                          ? colors.primary
                          : colors.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (_debugInfo != null && _activeFilter == null) ...[
              const SizedBox(height: 4),
              Text(
                _debugInfo!,
                style: GoogleFonts.inter(fontSize: 9, color: colors.outline),
                textAlign: TextAlign.center,
              ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: colors.outline,
                        ),
                      ),
                    )
                  : displayed.isEmpty
                  ? Center(
                      child: Text(
                        'No options available',
                        style: TextStyle(color: colors.outline),
                      ),
                    )
                  : ListView.separated(
                      itemCount: displayed.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final rawItem = displayed[index];
                        final rows = RecordDisplayUtils.extractDisplayRows(
                          rawItem,
                        );

                        // Resolve code: Match targetFieldKey if present in rawItem, otherwise fallback to first display row
                        String code = '';
                        if (widget.targetFieldKey != null &&
                            widget.targetFieldKey!.isNotEmpty) {
                          final matchKey = rawItem.keys.firstWhere(
                            (k) =>
                                k.toLowerCase() ==
                                widget.targetFieldKey!.toLowerCase(),
                            orElse: () => '',
                          );
                          if (matchKey.isNotEmpty &&
                              rawItem[matchKey] != null) {
                            code = rawItem[matchKey].toString();
                          }
                        }
                        if (code.isEmpty && rows.isNotEmpty) {
                          code = rows.first.$2;
                        }

                        final label = rows.length > 1
                            ? '${rows[0].$2} - ${rows[1].$2}'
                            : code;
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
