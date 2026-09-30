import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_lookup_sheet.dart';

class RecordFormField extends StatefulWidget {
  final EntityFieldMetadata field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final FormFieldSetter<String> onSaved;

  const RecordFormField({
    super.key,
    required this.field,
    this.initialValue,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  State<RecordFormField> createState() => _RecordFormFieldState();
}

class _RecordFormFieldState extends State<RecordFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openLov() {
    RecordLookupSheet.show(
      context,
      title: widget.field.label,
      projection: widget.field.lovProjection ?? '',
      lovReference: widget.field.lovReference ?? '',
      onSelected: (val) {
        setState(() => _controller.text = val);
        widget.onChanged(val);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (widget.field.options.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          initialValue: widget.initialValue?.toString() ?? widget.field.options.first,
          dropdownColor: colors.surfaceCard,
          style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
          decoration: _decoration(colors),
          items: widget.field.options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: widget.onChanged,
        ),
      );
    }

    final hasLov = widget.field.lovReference != null && widget.field.lovReference!.isNotEmpty;
    final isNum = widget.field.type == FieldType.number;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controller,
        readOnly: hasLov,
        onTap: hasLov ? _openLov : null,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
        decoration: _decoration(
          colors,
          suffixIcon: hasLov
              ? IconButton(
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined, size: 18),
                  onPressed: _openLov,
                )
              : null,
        ),
        validator: widget.field.isRequired
            ? (val) => (val == null || val.trim().isEmpty) ? '${widget.field.label} is required' : null
            : null,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
      ),
    );
  }

  InputDecoration _decoration(AppPalette colors, {Widget? suffixIcon}) => InputDecoration(
        labelText: widget.field.label,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: colors.outline),
        filled: true,
        fillColor: colors.surfaceCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: suffixIcon,
      );
}
