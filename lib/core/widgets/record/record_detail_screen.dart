import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../utils/icon_resolver.dart';
import 'record_action_sheet.dart';

class RecordDetailScreen extends StatefulWidget {
  final EntitySchemaMetadata schema;
  final Map<String, dynamic> record;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;

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

  @override
  void initState() {
    super.initState();
    _record = Map<String, dynamic>.from(widget.record);
  }

  void _triggerAction(EntityActionMetadata action) {
    RecordActionSheet.show(
      context,
      title: action.label,
      actionLabel: 'Confirm',
      fields: action.formFields,
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
    final code = _record[cardMeta.codeField]?.toString() ?? '';
    final title = _record[cardMeta.primaryField]?.toString() ?? '';
    final recordActions = widget.schema.actions.where((a) => a.scope == ActionScope.record).toList();

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        title: Text(code.isNotEmpty ? code : widget.schema.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(code, style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary)),
                  const SizedBox(height: 4),
                  Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...widget.schema.fields.map((f) {
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
                    children: [
                      Text(f.label, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)),
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
}
