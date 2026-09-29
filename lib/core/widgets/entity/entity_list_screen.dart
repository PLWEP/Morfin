import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../services/navigator_service.dart';
import 'entity_action_sheet.dart';
import 'entity_bulk_action_runner.dart';
import 'entity_card.dart';
import 'entity_item_handler.dart';

class EntityListScreen extends StatefulWidget {
  final EntitySchemaMetadata schema;
  final Future<List<Map<String, dynamic>>> Function({int skip, int top}) fetchRecords;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;
  final int pageSize;
  final String? nodeId, columnConfig, itemClickAction, itemClickTarget, itemClickFields;

  const EntityListScreen({
    super.key, required this.schema, required this.fetchRecords, this.onExecuteAction,
    this.pageSize = 20, this.nodeId, this.columnConfig, this.itemClickAction, this.itemClickTarget, this.itemClickFields,
  });

  @override
  State<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
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
      if (_scrollController.hasClients && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMoreRecords();
      }
    });
    _loadLiveRecords();
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  void _loadLiveRecords() async {
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

  List<Map<String, dynamic>> get _filteredRecords {
    if (_searchQuery.isEmpty) return _records;
    final q = _searchQuery.toLowerCase();
    return _records.where((r) => r.values.any((v) => v != null && v.toString().toLowerCase().contains(q))).toList();
  }

  void _toggleSelection(Map<String, dynamic> record) {
    setState(() {
      if (_selectedRecords.contains(record)) {
        _selectedRecords.remove(record);
        if (_selectedRecords.isEmpty) _isSelectionMode = false;
      } else {
        _selectedRecords.add(record);
        _isSelectionMode = true;
      }
    });
  }

  void _exitSelectionMode() => setState(() { _isSelectionMode = false; _selectedRecords.clear(); });

  void _selectAll(List<Map<String, dynamic>> displayed) {
    setState(() {
      if (_selectedRecords.length == displayed.length) {
        _selectedRecords.clear();
        _isSelectionMode = false;
      } else {
        _selectedRecords.addAll(displayed);
        _isSelectionMode = true;
      }
    });
  }

  void _handleItemTap(Map<String, dynamic> record) {
    EntityItemHandler.handleTap(
      context, schema: widget.schema, record: record, nodeId: widget.nodeId,
      itemClickAction: widget.itemClickAction, itemClickTarget: widget.itemClickTarget,
      itemClickFields: widget.itemClickFields, onExecuteAction: widget.onExecuteAction,
      onRefresh: _loadLiveRecords,
    );
  }

  void _openCreateSheet(EntityActionMetadata action) {
    EntityActionSheet.show(
      context, title: action.label, actionLabel: 'Save', fields: action.formFields,
      onSubmit: (values) async {
        if (widget.onExecuteAction != null) {
          await widget.onExecuteAction!(action.name, values);
          _loadLiveRecords();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final displayed = _filteredRecords;
    final createAction = widget.schema.actions.where((a) => a.scope == ActionScope.global).firstOrNull;
    final childActions = (widget.nodeId != null)
        ? NavigatorService.instance.getChildActions(widget.nodeId!).where((a) => (a['ActionType'] as String?)?.toUpperCase() == 'ACTION').toList()
        : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard, elevation: 0,
        leading: _isSelectionMode
            ? IconButton(icon: const Icon(Icons.close_rounded), onPressed: _exitSelectionMode)
            : IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 20), onPressed: () => Navigator.of(context).pop()),
        title: Text(
          _isSelectionMode ? '${_selectedRecords.length} selected' : widget.schema.title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface),
        ),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: Icon(_selectedRecords.length == displayed.length ? Icons.deselect_rounded : Icons.select_all_rounded),
              onPressed: () => _selectAll(displayed),
            )
          else
            IconButton(icon: const Icon(Icons.refresh_rounded, size: 20), onPressed: _isLoading ? null : _loadLiveRecords),
        ],
      ),
      bottomNavigationBar: (_isSelectionMode && _selectedRecords.isNotEmpty && childActions.isNotEmpty)
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), color: colors.surfaceCard,
              child: Row(
                children: childActions.map((act) {
                  final label = (act['Label'] ?? act['CleanLabel'] ?? 'Action').toString();
                  final targetUrl = act['TargetUrl'] as String?;
                  final parts = (targetUrl ?? '').split('.svc/');
                  final proj = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : widget.schema.projection;
                  final actionName = parts.length > 1 ? parts[1].split('?')[0] : label;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilledButton.tonal(
                        onPressed: () => EntityBulkActionRunner.execute(
                          context: context, label: label, actionName: actionName, projection: proj,
                          records: _selectedRecords.toList(), onExecuteAction: widget.onExecuteAction,
                          onSuccess: () { _exitSelectionMode(); _loadLiveRecords(); },
                        ),
                        child: Text('$label (${_selectedRecords.length})', maxLines: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : null,
      floatingActionButton: (createAction != null && widget.onExecuteAction != null && !_isSelectionMode)
          ? FloatingActionButton.extended(
              onPressed: () => _openCreateSheet(createAction), backgroundColor: colors.primary, foregroundColor: colors.surfaceDeep,
              icon: const Icon(Icons.add_rounded, size: 18), label: Text(createAction.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            )
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: colors.surfaceCard,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search ${widget.schema.title}...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.outline),
                prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.outline),
                filled: true, fillColor: colors.surfaceContainerLow, contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.wifi_off_rounded, size: 36, color: colors.statusCritical), const SizedBox(height: 8),
          Text('Failed to sync live data', style: TextStyle(color: colors.onSurface)),
          TextButton(onPressed: _loadLiveRecords, child: const Text('Retry')),
        ]),
      );
    }
    if (displayed.isEmpty) return Center(child: Text('No records found', style: TextStyle(color: colors.outline)));

    return RefreshIndicator(
      onRefresh: () async => _loadLiveRecords(),
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
            schema: widget.schema, record: record, columnConfig: widget.columnConfig,
            isSelectionMode: _isSelectionMode, isSelected: _selectedRecords.contains(record),
            onTap: () {
              if (_isSelectionMode) {
                _toggleSelection(record);
              } else {
                _handleItemTap(record);
              }
            },
            onLongPress: () => _toggleSelection(record),
          );
        },
      ),
    );
  }
}
