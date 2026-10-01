import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';

class RecordLookupSheet extends StatefulWidget {
  final String title;
  final String projection;
  final String lovReference;
  final ValueChanged<String>? onSelected;
  final void Function(String code, String display)? onRecordSelected;

  const RecordLookupSheet({
    super.key,
    required this.title,
    required this.projection,
    required this.lovReference,
    this.onSelected,
    this.onRecordSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String projection,
    required String lovReference,
    ValueChanged<String>? onSelected,
    void Function(String code, String display)? onRecordSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordLookupSheet(
        title: title,
        projection: projection,
        lovReference: lovReference,
        onSelected: onSelected,
        onRecordSelected: onRecordSelected,
      ),
    );
  }

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
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Projection name is missing for LOV "${widget.title}"';
        });
      }
      return;
    }

    final ref = widget.lovReference.trim();
    if (ref.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'LOV reference name is missing';
        });
      }
      return;
    }

    final entitySet = ref.startsWith('Reference_') ? ref : 'Reference_$ref';

    try {
      final res = await BackendService.instance.fetchEntitySet(
        projection: proj,
        entitySet: entitySet,
        query: const DataQuery(top: 50),
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
            final filtered = Map.fromEntries(r.entries.where((e) => !_isMetadataKey(e.key)));
            return filtered.values.any((v) => v != null && v.toString().toLowerCase().contains(_search.toLowerCase()));
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
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(fontSize: 12, color: colors.outline),
                                ),
                              ],
                            ),
                          ),
                        )
                      : displayed.isEmpty
                          ? Center(child: Text('No options available', style: TextStyle(color: colors.outline)))
                          : ListView.separated(
                              itemCount: displayed.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                                itemBuilder: (_, index) {
                                  final item = displayed[index];
                                  final rows = _extractDisplayRows(item);
                                  final selectedCode = rows.isNotEmpty ? rows.first.$2 : '';
                                  final displayLabel = rows.length > 1
                                      ? '${rows[0].$2} - ${rows[1].$2}'
                                      : selectedCode;

                                return InkWell(
                                  onTap: () {
                                    if (widget.onRecordSelected != null) {
                                      widget.onRecordSelected!(selectedCode, displayLabel);
                                    } else if (widget.onSelected != null) {
                                      widget.onSelected!(selectedCode);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  splashColor: colors.primary.withValues(alpha: 0.1),
                                  highlightColor: colors.surfaceContainerLow,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: rows.map((r) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              ConstrainedBox(
                                                constraints: const BoxConstraints(minWidth: 85, maxWidth: 120),
                                                child: Text(
                                                  r.$1,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: colors.outline,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  ':',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: colors.outlineVariant,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  r.$2,
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: colors.onSurface,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isMetadataKey(String key) {
    final lower = key.toLowerCase();
    return lower == 'luname' ||
        lower == 'keyref' ||
        lower == 'objid' ||
        lower == 'objversion' ||
        lower == 'objkey' ||
        lower == 'objstate' ||
        lower == 'objevents' ||
        lower.startsWith('@odata');
  }

  List<(String, String)> _extractDisplayRows(Map<String, dynamic> item) {
    final entries = item.entries.where((e) => !_isMetadataKey(e.key) && e.value != null).toList();
    if (entries.isEmpty) return const [];

    return entries.take(2).map((e) {
      final label = _formatLabel(e.key);
      final value = e.value.toString();
      return (label, value);
    }).toList();
  }

  String _formatLabel(String key) {
    return key.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}');
  }
}
