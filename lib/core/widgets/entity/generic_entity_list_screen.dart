import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'generic_entity_card.dart';
import 'generic_entity_detail_screen.dart';
import 'generic_form_sheet.dart';

class GenericEntityListScreen extends StatefulWidget {
  final EntitySchemaMetadata schema;
  final Future<List<Map<String, dynamic>>> Function() fetchRecords;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;

  const GenericEntityListScreen({
    super.key,
    required this.schema,
    required this.fetchRecords,
    this.onExecuteAction,
  });

  @override
  State<GenericEntityListScreen> createState() => _GenericEntityListScreenState();
}

class _GenericEntityListScreenState extends State<GenericEntityListScreen> {
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLiveRecords();
  }

  Future<void> _loadLiveRecords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await widget.fetchRecords();
      if (mounted) setState(() => _records = data);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    if (_searchQuery.isEmpty) return _records;
    final q = _searchQuery.toLowerCase();
    return _records.where((r) => r.values.any((v) => v != null && v.toString().toLowerCase().contains(q))).toList();
  }

  void _openCreateSheet(EntityActionMetadata action) {
    GenericFormSheet.show(
      context,
      title: action.label,
      actionLabel: 'Save',
      fields: action.formFields,
      onSubmit: (values) async {
        await widget.onExecuteAction!(action.name, values);
        await _loadLiveRecords();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.schema.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded, size: 20), onPressed: _isLoading ? null : _loadLiveRecords),
        ],
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 36, color: colors.statusCritical),
            const SizedBox(height: 8),
            Text('Failed to sync live data', style: TextStyle(color: colors.onSurface)),
            TextButton(onPressed: _loadLiveRecords, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (displayed.isEmpty) return Center(child: Text('No records found', style: TextStyle(color: colors.outline)));

    return RefreshIndicator(
      onRefresh: _loadLiveRecords,
      color: colors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: displayed.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => GenericEntityCard(
          schema: widget.schema,
          record: displayed[index],
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GenericEntityDetailScreen(
                  schema: widget.schema,
                  record: displayed[index],
                  onExecuteAction: widget.onExecuteAction,
                ),
              ),
            );
            _loadLiveRecords();
          },
        ),
      ),
    );
  }
}
