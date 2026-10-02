import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_form_field.dart';

class RecordArrayItemDialog extends StatefulWidget {
  final EntityFieldMetadata parentField;
  final Map<String, dynamic>? existingItem;
  final Map<String, dynamic> defaultValues;
  final Map<String, dynamic> parentValues;

  const RecordArrayItemDialog({
    super.key,
    required this.parentField,
    this.existingItem,
    this.defaultValues = const {},
    this.parentValues = const {},
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required EntityFieldMetadata parentField,
    Map<String, dynamic>? existingItem,
    Map<String, dynamic> defaultValues = const {},
    Map<String, dynamic> parentValues = const {},
  }) => showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RecordArrayItemDialog(
      parentField: parentField,
      existingItem: existingItem,
      defaultValues: defaultValues,
      parentValues: parentValues,
    ),
  );

  @override
  State<RecordArrayItemDialog> createState() => _RecordArrayItemDialogState();
}

class _RecordArrayItemDialogState extends State<RecordArrayItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _draft;

  @override
  void initState() {
    super.initState();
    _draft = Map<String, dynamic>.from(widget.existingItem ?? {});

    // Prefill for child fields if creating a new item
    if (widget.existingItem == null) {
      // 1. Generic Auto-Cascade: inherit values from parent/header if field names match
      for (final sf in widget.parentField.nestedFields) {
        final matchParentEntry = widget.parentValues.entries.firstWhere(
          (e) => e.key.toLowerCase() == sf.key.toLowerCase() && e.value != null && e.value.toString().isNotEmpty,
          orElse: () => const MapEntry('', null),
        );
        if (matchParentEntry.key.isNotEmpty) {
          _draft[sf.key] = matchParentEntry.value;
        }
      }

      // 2. Prefill configured default values (prefixed or direct match)
      final parentPrefix = '${widget.parentField.key.toLowerCase()}.';
      for (final entry in widget.defaultValues.entries) {
        final k = entry.key.toLowerCase();
        if (k.startsWith(parentPrefix)) {
          final subKey = entry.key.substring(widget.parentField.key.length + 1);
          _draft[subKey] = entry.value;
        } else if (widget.parentField.nestedFields.any((nf) => nf.key.toLowerCase() == k)) {
          final matchedField = widget.parentField.nestedFields.firstWhere((nf) => nf.key.toLowerCase() == k);
          _draft[matchedField.key] = entry.value;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final rawSubFields = widget.parentField.nestedFields;

    final subFields = rawSubFields.map((sf) {
      if (sf.lovProjection == null || sf.lovProjection!.isEmpty) {
        return sf.copyWith(lovProjection: widget.parentField.lovProjection);
      }
      return sf;
    }).toList();

    final insets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: colors.surfaceBorder)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + insets),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.existingItem != null ? 'Edit ${widget.parentField.label} Item' : 'Add ${widget.parentField.label} Item',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              if (subFields.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No fields configured for this line item.',
                      style: GoogleFonts.inter(fontSize: 13, color: colors.outline),
                    ),
                  ),
                )
              else
                ...subFields.map((sf) => RecordFormField(
                  field: sf,
                  initialValue: _draft[sf.key],
                  contextualValues: <String, dynamic>{...widget.parentValues, ..._draft},
                  onChanged: (val) => setState(() => _draft[sf.key] = val),
                  onSaved: (val) => _draft[sf.key] = val?.trim() ?? '',
                )),
              const SizedBox(height: 16),
              if (subFields.isNotEmpty)
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    Navigator.of(context).pop(_draft);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(widget.existingItem != null ? 'Update' : 'Add Item'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
