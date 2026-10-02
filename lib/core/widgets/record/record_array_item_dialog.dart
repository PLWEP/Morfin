import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_form_field.dart';

class RecordArrayItemDialog extends StatelessWidget {
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
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final formKey = GlobalKey<FormState>();
    final draft = Map<String, dynamic>.from(existingItem ?? {});

    // Prefill for child fields if creating a new item
    if (existingItem == null) {
      // 1. Generic Auto-Cascade: inherit values from parent/header if field names match
      for (final sf in parentField.nestedFields) {
        final matchParentEntry = parentValues.entries.firstWhere(
          (e) => e.key.toLowerCase() == sf.key.toLowerCase() && e.value != null && e.value.toString().isNotEmpty,
          orElse: () => const MapEntry('', null),
        );
        if (matchParentEntry.key.isNotEmpty) {
          draft[sf.key] = matchParentEntry.value;
        }
      }

      // 2. Prefill configured default values (prefixed or direct match)
      final parentPrefix = '${parentField.key.toLowerCase()}.';
      for (final entry in defaultValues.entries) {
        final k = entry.key.toLowerCase();
        if (k.startsWith(parentPrefix)) {
          final subKey = entry.key.substring(parentField.key.length + 1);
          draft[subKey] = entry.value;
        } else if (parentField.nestedFields.any((nf) => nf.key.toLowerCase() == k)) {
          final matchedField = parentField.nestedFields.firstWhere((nf) => nf.key.toLowerCase() == k);
          draft[matchedField.key] = entry.value;
        }
      }
    }

    final rawSubFields = parentField.nestedFields;

    final subFields = rawSubFields.map((sf) {
      if (sf.lovProjection == null || sf.lovProjection!.isEmpty) {
        return sf.copyWith(lovProjection: parentField.lovProjection);
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
        key: formKey,
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
                existingItem != null ? 'Edit ${parentField.label} Item' : 'Add ${parentField.label} Item',
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
                ...subFields.map(
                  (sf) {
                    return RecordFormField(
                      field: sf,
                      initialValue: draft[sf.key],
                      onChanged: (val) => draft[sf.key] = val,
                      onSaved: (val) => draft[sf.key] = val?.trim() ?? '',
                    );
                  },
                ),
              const SizedBox(height: 16),
              if (subFields.isNotEmpty)
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    formKey.currentState!.save();
                    Navigator.of(context).pop(draft);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(existingItem != null ? 'Update' : 'Add Item'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
