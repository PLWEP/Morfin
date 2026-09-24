import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'generic_form_field.dart';

class GenericFormSheet extends StatefulWidget {
  final String title;
  final String actionLabel;
  final List<EntityFieldMetadata> fields;
  final Map<String, dynamic> initialValues;
  final Future<void> Function(Map<String, dynamic> values) onSubmit;

  const GenericFormSheet({
    super.key,
    required this.title,
    this.actionLabel = 'Submit',
    required this.fields,
    this.initialValues = const {},
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    String actionLabel = 'Submit',
    required List<EntityFieldMetadata> fields,
    Map<String, dynamic> initialValues = const {},
    required Future<void> Function(Map<String, dynamic> values) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GenericFormSheet(
        title: title,
        actionLabel: actionLabel,
        fields: fields,
        initialValues: initialValues,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<GenericFormSheet> createState() => _GenericFormSheetState();
}

class _GenericFormSheetState extends State<GenericFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _values;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues);
    for (final field in widget.fields) {
      if (!_values.containsKey(field.key) && field.options.isNotEmpty) {
        _values[field.key] = field.options.first;
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_values);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.fields.map(
                (f) => GenericFormField(
                  field: f,
                  initialValue: _values[f.key],
                  onChanged: (val) => _values[f.key] = val,
                  onSaved: (val) => _values[f.key] = val?.trim() ?? '',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.surfaceDeep,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: colors.surfaceDeep),
                      )
                    : Text(
                        widget.actionLabel,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
