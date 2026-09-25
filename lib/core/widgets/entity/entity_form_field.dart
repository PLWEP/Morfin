import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';

class EntityFormField extends StatelessWidget {
  final EntityFieldMetadata field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final FormFieldSetter<String> onSaved;

  const EntityFormField({
    super.key,
    required this.field,
    this.initialValue,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (field.options.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          initialValue: initialValue?.toString() ?? field.options.first,
          dropdownColor: colors.surfaceCard,
          style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
          decoration: _decoration(colors),
          items: field.options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: onChanged,
        ),
      );
    }

    final isNum = field.type == FieldType.number;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue?.toString(),
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
        decoration: _decoration(colors),
        validator: field.isRequired
            ? (val) => (val == null || val.trim().isEmpty) ? '${field.label} is required' : null
            : null,
        onSaved: onSaved,
      ),
    );
  }

  InputDecoration _decoration(AppPalette colors) => InputDecoration(
        labelText: field.label,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: colors.outline),
        filled: true,
        fillColor: colors.surfaceCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );
}
