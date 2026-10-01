import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';

class RecordLookupSheet extends StatefulWidget {
  final String title;
  final String projection;
  final String lovReference;
  final ValueChanged<String> onSelected;

  const RecordLookupSheet({
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
      builder: (_) => RecordLookupSheet(
        title: title,
        projection: projection,
        lovReference: lovReference,
        onSelected: onSelected,
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

    final candidates = <String>[];
    if (ref.startsWith('Reference_')) {
      candidates.add(ref);
      candidates.add(ref.substring('Reference_'.length));
    } else {
      candidates.add('Reference_$ref');
      candidates.add('${ref}Set');
      candidates.add(ref);
    }

    String? lastError;
    for (final entitySet in candidates) {
      try {
        final res = await BackendService.instance.fetchEntitySet(
          projection: proj,
          entitySet: entitySet,
          query: const DataQuery(top: 50),
        );
        if (res.isNotEmpty && mounted) {
          setState(() {
            _items = res;
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        lastError = e.toString();
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_items.isEmpty && lastError != null) {
          _errorMessage = lastError;
        }
      });
    }
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
