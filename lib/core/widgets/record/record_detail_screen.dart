import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/record_metadata.dart';
import '../../services/schema_catalog_service.dart';
import '../../utils/icon_resolver.dart';
import 'record_action_sheet.dart';

class RecordDetailScreen extends StatefulWidget {
  final RecordSchemaMetadata schema;
  final Map<String, dynamic> record;
  final Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;

  const RecordDetailScreen({
    super.key,
    required this.schema,
    required this.record,
    this.onExecuteAction,
  });

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late Map<String, dynamic> _record;
  List<RecordFieldMetadata> _fields = [];
  bool _isLoadingFields = false;

  @override
  void initState() {
    super.initState();
    _record = Map<String, dynamic>.from(widget.record);
    _fields = List.from(widget.schema.fields);
    if (_fields.isEmpty && widget.schema.projection.isNotEmpty) {
      _loadDynamicFields();
    }
  }

  Future<void> _loadDynamicFields() async {
    setState(() => _isLoadingFields = true);
    try {
      final fetched = await SchemaCatalogService.instance.fetchRecordFields(
        projection: widget.schema.projection,
        collectionOrType: widget.schema.entitySet.isNotEmpty ? widget.schema.entitySet : widget.schema.entityName,
      );
      if (mounted && fetched.isNotEmpty) {
        setState(() => _fields = fetched);
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoadingFields = false);
    }
  }

  void _triggerAction(RecordActionMetadata action) {
    RecordActionSheet.show(
      context,
      title: action.label,
      actionLabel: 'Confirm',
      fields: action.formFields.isNotEmpty ? action.formFields : _fields,
      initialValues: _record,
      onSubmit: (values) async {
        final payload = {..._record, ...values};
        if (widget.onExecuteAction != null) {
          await widget.onExecuteAction!(action.name, payload);
        }
        if (mounted) setState(() => _record.addAll(values));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cardMeta = widget.schema.listCard;
    final code = (_record[cardMeta.codeField] ?? _record['OrderNo'] ?? _record['PartNo'] ?? _record['RequisitionNo'] ?? '').toString();
    final recordActions = widget.schema.actions.where((a) => a.scope == ActionScope.record).toList();

    final displayFields = _fields.isNotEmpty ? _fields : _buildFallbackFieldsFromRecord();

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        title: Text(code.isNotEmpty ? code : widget.schema.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              if (widget.schema.projection.isNotEmpty) _loadDynamicFields();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoadingFields)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else
              ...displayFields.map((f) {
                final val = _record[f.key]?.toString() ?? '-';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(f.label, style: GoogleFonts.inter(fontSize: 12, color: colors.outline))),
                        const SizedBox(width: 12),
                        Flexible(child: Text(val, textAlign: TextAlign.end, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface))),
                      ],
                    ),
                  ),
                );
              }),
            if (recordActions.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...recordActions.map((act) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _triggerAction(act),
                      icon: Icon(IconResolver.resolve(act.icon)),
                      label: Text(act.label),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.surfaceContainerHigh,
                        foregroundColor: colors.onSurface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  List<RecordFieldMetadata> _buildFallbackFieldsFromRecord() {
    const internalKeys = {'luname', 'objid', 'objversion', 'rowkey', 'rowstate', 'rowtype', 'objsite', 'objstate', 'objgrants'};
    return _record.entries
        .where((e) => !e.key.startsWith('@') && !internalKeys.contains(e.key.toLowerCase()))
        .map((e) {
          final label = e.key.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (m) => ' ${m.group(0)}').replaceAll('_', ' ').trim();
          return RecordFieldMetadata(key: e.key, label: label);
        })
        .toList();
  }
}
