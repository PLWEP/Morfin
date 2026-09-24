import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../utils/icon_resolver.dart';
import 'generic_form_sheet.dart';

class GenericEntityDetailScreen extends StatefulWidget {
  final EntitySchemaMetadata schema;
  final Map<String, dynamic> record;
  final Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction;

  const GenericEntityDetailScreen({
    super.key,
    required this.schema,
    required this.record,
    this.onExecuteAction,
  });

  @override
  State<GenericEntityDetailScreen> createState() => _GenericEntityDetailScreenState();
}

class _GenericEntityDetailScreenState extends State<GenericEntityDetailScreen> {
  late Map<String, dynamic> _record;

  @override
  void initState() {
    super.initState();
    _record = Map<String, dynamic>.from(widget.record);
  }

  void _triggerAction(EntityActionMetadata action) {
    GenericFormSheet.show(
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
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.schema.title, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)),
            Text(code, style: GoogleFonts.robotoMono(fontSize: 15, fontWeight: FontWeight.w700, color: colors.primary)),
          ],
        ),
      ),
      bottomNavigationBar: recordActions.isNotEmpty && widget.onExecuteAction != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                border: Border(top: BorderSide(color: colors.surfaceBorder)),
              ),
              child: Row(
                children: recordActions.map((action) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () => _triggerAction(action),
                        icon: Icon(IconResolver.resolve(action.icon, fallback: Icons.bolt_rounded), size: 16),
                        label: Text(action.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.surfaceDeep,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Icon(IconResolver.resolve(widget.schema.icon), size: 20, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: colors.onSurface)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('ATTRIBUTES', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: colors.outline)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.schema.fields.length,
                separatorBuilder: (_, _) => Divider(height: 1, color: colors.surfaceBorder),
                itemBuilder: (context, index) {
                  final field = widget.schema.fields[index];
                  final val = _record[field.key]?.toString() ?? '-';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(field.label, style: GoogleFonts.inter(fontSize: 12, color: colors.outline)),
                        Flexible(
                          child: Text(
                            val,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface),
                          ),
                        ),
                      ],
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
}
