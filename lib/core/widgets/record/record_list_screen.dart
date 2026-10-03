import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/record_metadata.dart';
import '../../services/navigator_service.dart';
import '../../services/schema_catalog_service.dart';
import 'record_action_sheet.dart';
import 'record_bulk_action_bar.dart';
import 'record_item_handler.dart';
import 'record_list_content.dart';

class RecordListScreen extends StatefulWidget {
  final RecordSchemaMetadata schema;
  final Future<List<Map<String, dynamic>>> Function({int skip, int top}) fetchRecords;
  final Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;
  final int pageSize;
  final String? nodeId, columnConfig, itemClickAction, itemClickTarget, itemClickFields;

  const RecordListScreen({
    super.key, required this.schema, required this.fetchRecords, this.onExecuteAction,
    this.pageSize = 20, this.nodeId, this.columnConfig, this.itemClickAction, this.itemClickTarget, this.itemClickFields,
  });

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true, _isLoadingMore = false, _hasMore = true, _isSelectionMode = false;
  final Set<Map<String, dynamic>> _selectedRecords = {};
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) _loadMoreRecords();
    });
    _loadLiveRecords();
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  Future<void> _loadLiveRecords() async {
    setState(() { _isLoading = true; _error = null; _hasMore = true; });
    SchemaCatalogService.instance.invalidateProjection(widget.schema.projection);
    try {
      final data = await widget.fetchRecords(skip: 0, top: widget.pageSize);
      if (mounted) setState(() { _records = data; _hasMore = data.length >= widget.pageSize; });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadMoreRecords() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final more = await widget.fetchRecords(skip: _records.length, top: widget.pageSize);
      if (mounted) setState(() { _records.addAll(more); _hasMore = more.length >= widget.pageSize; });
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _triggerCreateAction() {
    final createAction = widget.schema.actions.firstWhere(
      (a) => a.scope == ActionScope.global,
      orElse: () => RecordActionMetadata(name: 'Create', label: 'Create ${widget.schema.title}', formFields: widget.schema.fields),
    );
    RecordActionSheet.show(
      context, title: createAction.label, actionLabel: 'Create', fields: createAction.formFields,
      onSubmit: (values) async {
        if (widget.onExecuteAction != null) await widget.onExecuteAction!(createAction.name, values);
        await _loadLiveRecords();
      },
    );
  }

  List<Map<String, dynamic>> get _filteredRecords => _searchQuery.isEmpty ? _records : _records.where((r) => r.values.any((v) => v != null && v.toString().toLowerCase().contains(_searchQuery.toLowerCase()))).toList();

  void _toggleSelection(Map<String, dynamic> record) {
    setState(() {
      if (!_selectedRecords.remove(record)) _selectedRecords.add(record);
      if (_selectedRecords.isEmpty) _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _filteredRecords;
    final childActions = (widget.nodeId != null && widget.nodeId!.isNotEmpty)
        ? NavigatorService.instance.getChildActions(widget.nodeId!)
        : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        title: Text(_isSelectionMode ? '${_selectedRecords.length} selected' : widget.schema.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
        leading: _isSelectionMode ? IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => setState(() { _isSelectionMode = false; _selectedRecords.clear(); })) : null,
        actions: [
          if (!_isSelectionMode && childActions.isNotEmpty && displayed.isNotEmpty)
            IconButton(icon: const Icon(Icons.checklist_rounded), tooltip: 'Batch Select', onPressed: () => setState(() => _isSelectionMode = true)),
          IconButton(icon: const Icon(Icons.refresh_rounded), tooltip: 'Refresh live data', onPressed: _loadLiveRecords),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search ${widget.schema.title.toLowerCase()}...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () => setState(() => _searchQuery = '')) : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: RecordListContent(
        scrollController: _scrollController,
        schema: widget.schema,
        columnConfig: widget.columnConfig,
        displayed: displayed,
        isLoading: _isLoading,
        isLoadingMore: _isLoadingMore,
        error: _error,
        isSelectionMode: _isSelectionMode,
        selectedRecords: _selectedRecords,
        onItemTap: (record) => _isSelectionMode
            ? _toggleSelection(record)
            : RecordItemHandler.handleTap(
                context, schema: widget.schema, record: record, nodeId: widget.nodeId,
                itemClickAction: widget.itemClickAction, itemClickTarget: widget.itemClickTarget, itemClickFields: widget.itemClickFields,
                onExecuteAction: widget.onExecuteAction, onRefresh: _loadLiveRecords,
              ),
        onDetailTap: (record) => RecordItemHandler.openDetail(
          context, schema: widget.schema, record: record, onExecuteAction: widget.onExecuteAction, onRefresh: _loadLiveRecords,
        ),
        onItemLongPress: (record) {
          if (!_isSelectionMode && childActions.isNotEmpty) {
            setState(() { _isSelectionMode = true; _selectedRecords.add(record); });
          }
        },
        onRefresh: _loadLiveRecords,
      ),
      bottomNavigationBar: (_isSelectionMode && _selectedRecords.isNotEmpty && childActions.isNotEmpty)
          ? RecordBulkActionBar(
              childActions: childActions,
              selectedRecords: _selectedRecords.toList(),
              fallbackProjection: widget.schema.projection,
              onExecuteAction: widget.onExecuteAction,
              onSuccess: () { setState(() { _isSelectionMode = false; _selectedRecords.clear(); }); _loadLiveRecords(); },
            )
          : null,
      floatingActionButton: (!_isSelectionMode && widget.schema.actions.any((a) => a.scope == ActionScope.global))
          ? FloatingActionButton.extended(
              onPressed: _triggerCreateAction,
              icon: const Icon(Icons.add_rounded),
              label: Text('New ${widget.schema.title}'),
            )
          : null,
    );
  }
}
