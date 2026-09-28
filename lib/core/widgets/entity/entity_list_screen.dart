import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'entity_action_sheet.dart';
import 'entity_card.dart';
import 'entity_detail_screen.dart';

class EntityListScreen extends StatefulWidget {
  final EntitySchemaMetadata schema;
  final Future<List<Map<String, dynamic>>> Function({int skip, int top}) fetchRecords;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;
  final int pageSize;

  const EntityListScreen({
    super.key,
    required this.schema,
    required this.fetchRecords,
    this.onExecuteAction,
    this.pageSize = 20,
  });

  @override
  State<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true, _isLoadingMore = false, _hasMore = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadLiveRecords();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRecords();
    }
  }

  Future<void> _loadLiveRecords() async {
    setState(() { _isLoading = true; _error = null; _hasMore = true; });
    try {
      final data = await widget.fetchRecords(skip: 0, top: widget.pageSize);
      if (mounted) setState(() { _records = data; _hasMore = data.length >= widget.pageSize; });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreRecords() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final more = await widget.fetchRecords(skip: _records.length, top: widget.pageSize);
      if (mounted) setState(() { _records.addAll(more); _hasMore = more.length >= widget.pageSize; });
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    if (_searchQuery.isEmpty) return _records;
    final q = _searchQuery.toLowerCase();
    return _records.where((r) => r.values.any((v) => v != null && v.toString().toLowerCase().contains(q))).toList();
  }

  void _openCreateSheet(EntityActionMetadata action) {
    EntityActionSheet.show(
      context,
      title: action.label,
      actionLabel: 'Save',
      fields: action.formFields,
      onSubmit: (values) async {
        if (widget.onExecuteAction != null) {
          await widget.onExecuteAction!(action.name, values);
          await _loadLiveRecords();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _filteredRecords;
    final createAction = widget.schema.actions.where((a) => a.scope == ActionScope.global).firstOrNull;

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 20), onPressed: () => Navigator.of(context).pop()),
        title: Text(widget.schema.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
        actions: [IconButton(icon: const Icon(Icons.refresh_rounded, size: 20), onPressed: _isLoading ? null : _loadLiveRecords)],
      ),
      floatingActionButton: (createAction != null && widget.onExecuteAction != null)
          ? FloatingActionButton.extended(
              onPressed: () => _openCreateSheet(createAction),
              backgroundColor: colors.primary,
              foregroundColor: colors.surfaceDeep,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(createAction.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            )
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colors.surfaceCard,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search ${widget.schema.title}...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.outline),
                prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.outline),
                filled: true,
                fillColor: colors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(child: _buildBody(colors, displayed)),
        ],
      ),
    );
  }

  Widget _buildBody(AppPalette colors, List<Map<String, dynamic>> displayed) {
    if (_isLoading) return Center(child: CircularProgressIndicator(color: colors.primary));
    if (_error != null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.wifi_off_rounded, size: 36, color: colors.statusCritical),
        const SizedBox(height: 8),
        Text('Failed to sync live data', style: TextStyle(color: colors.onSurface)),
        TextButton(onPressed: _loadLiveRecords, child: const Text('Retry')),
      ]));
    }
    if (displayed.isEmpty) return Center(child: Text('No records found', style: TextStyle(color: colors.outline)));

    return RefreshIndicator(
      onRefresh: _loadLiveRecords,
      color: colors.primary,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: displayed.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index >= displayed.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary)),
              ),
            );
          }
          final record = displayed[index];
          return EntityCard(
            schema: widget.schema,
            record: record,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EntityDetailScreen(schema: widget.schema, record: record, onExecuteAction: widget.onExecuteAction)),
              );
              _loadLiveRecords();
            },
          );
        },
      ),
    );
  }
}
