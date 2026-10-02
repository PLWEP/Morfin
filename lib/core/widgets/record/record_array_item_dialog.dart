import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_form_field.dart';

class RecordArrayItemDialog extends StatelessWidget {
  final EntityFieldMetadata parentField;
  final Map<String, dynamic>? existingItem;

  const RecordArrayItemDialog({
    super.key,
    required this.parentField,
    this.existingItem,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required EntityFieldMetadata parentField,
    Map<String, dynamic>? existingItem,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordArrayItemDialog(
        parentField: parentField,
        existingItem: existingItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final formKey = GlobalKey<FormState>();
    final draft = Map<String, dynamic>.from(existingItem ?? {});

    final rawSubFields = parentField.nestedFields.isNotEmpty
        ? parentField.nestedFields
        : const [
            EntityFieldMetadata(key: 'PartNo', label: 'Part No'),
            EntityFieldMetadata(key: 'Description', label: 'Description'),
            EntityFieldMetadata(key: 'Quantity', label: 'Quantity', type: FieldType.number, isRequired: true),
            EntityFieldMetadata(key: 'UnitMeasure', label: 'Unit of Measure'),
            EntityFieldMetadata(key: 'Price', label: 'Price', type: FieldType.number),
            EntityFieldMetadata(key: 'CurrencyCode', label: 'Currency'),
          ];

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
                existingItem != null ? 'Edit Line Item' : 'Add Line Item',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ...subFields.map(
                (sf) => RecordFormField(
                  field: sf,
                  initialValue: draft[sf.key],
                  onChanged: (val) => draft[sf.key] = val,
                  onSaved: (val) => draft[sf.key] = val?.trim() ?? '',
                ),
              ),
              const SizedBox(height: 16),
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
