import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/record_metadata.dart';
import 'record_array_field.dart';
import 'record_form_field.dart';

class RecordActionSheet extends StatefulWidget {
  final String title;
  final String actionLabel;
  final List<RecordFieldMetadata> fields;
  final Map<String, dynamic> initialValues;
  final Map<String, dynamic> paramDefaults;
  final Future<void> Function(Map<String, dynamic> values) onSubmit;

  final String? projection;

  const RecordActionSheet({
    super.key,
    required this.title,
    this.actionLabel = 'Submit',
    this.projection,
    required this.fields,
    this.initialValues = const {},
    this.paramDefaults = const {},
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    String actionLabel = 'Submit',
    String? projection,
    required List<RecordFieldMetadata> fields,
    Map<String, dynamic> initialValues = const {},
    Map<String, dynamic> paramDefaults = const {},
    required Future<void> Function(Map<String, dynamic> values) onSubmit,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RecordActionSheet(
      title: title,
      actionLabel: actionLabel,
      projection: projection,
      fields: fields,
      initialValues: initialValues,
      paramDefaults: paramDefaults,
      onSubmit: onSubmit,
    ),
  );

  @override
  State<RecordActionSheet> createState() => _RecordActionSheetState();
}

class _RecordActionSheetState extends State<RecordActionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _values;
  bool _isSubmitting = false;
  int _currentStep = 0;
  bool _isWizardMode = false;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues);
    for (final field in widget.fields) {
      if (!_values.containsKey(field.key) && field.options.isNotEmpty) {
        _values[field.key] = field.options.first;
      }
    }
    // Enable wizard mode if action has multiple fields and at least one barcode field
    final hasBarcode = widget.fields.any((f) =>
        f.type == FieldType.barcode ||
        f.key.toLowerCase().contains('barcode') ||
        f.key.toLowerCase().contains('scancode'));
    _isWizardMode = widget.fields.length >= 2 && hasBarcode;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    for (final field in widget.fields) {
      if (field.type == FieldType.array && field.isRequired) {
        final items = _values[field.key] as List<dynamic>?;
        if (items == null || items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please add at least one item to "${field.label}"'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
          );
          return;
        }
      }
    }

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
              Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: colors.outlineVariant, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(widget.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
              const SizedBox(height: 16),
              if (_isWizardMode && widget.fields.length > 1) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Step ${_currentStep + 1} of ${widget.fields.length}',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.onPrimaryContainer),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: Icon(_isWizardMode ? Icons.view_agenda_rounded : Icons.linear_scale_rounded, size: 16),
                      label: Text(_isWizardMode ? 'View All' : 'Wizard', style: GoogleFonts.inter(fontSize: 12)),
                      onPressed: () => setState(() => _isWizardMode = !_isWizardMode),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / widget.fields.length,
                  backgroundColor: colors.surfaceContainerHigh,
                  color: colors.primary,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 16),
              ],
              ...widget.fields.asMap().entries.map((entry) {
                final idx = entry.key;
                final f = entry.value;
                if (_isWizardMode && idx != _currentStep) {
                  return const SizedBox.shrink();
                }

                final resolved = (f.lovProjection == null || f.lovProjection!.isEmpty)
                    ? (widget.projection != null ? f.copyWith(lovProjection: widget.projection) : f)
                    : f;

                return resolved.type == FieldType.array
                    ? RecordArrayField(
                        field: resolved,
                        initialItems: (_values[resolved.key] as List<dynamic>?) ?? const [],
                        defaultValues: widget.paramDefaults,
                        parentValues: _values,
                        onParentFieldChanged: (key, val) => setState(() => _values[key] = val),
                        onChanged: (val) => setState(() => _values[resolved.key] = val),
                      )
                    : RecordFormField(
                        key: ValueKey('action_${resolved.key}'),
                        field: resolved,
                        initialValue: _values[resolved.key],
                        contextualValues: _values,
                        onChanged: (val) {
                          _values[resolved.key] = val;
                          if (_isWizardMode && _currentStep < widget.fields.length - 1 && val != null && val.toString().trim().isNotEmpty) {
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted && _currentStep < widget.fields.length - 1) {
                                setState(() => _currentStep++);
                              }
                            });
                          }
                        },
                        onSaved: (val) => _values[resolved.key] = val?.trim() ?? '',
                      );
              }),
              const SizedBox(height: 20),
              if (_isWizardMode && widget.fields.length > 1) ...[
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentStep--),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Back', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                if (_currentStep < widget.fields.length - 1) {
                                  setState(() => _currentStep++);
                                } else {
                                  _handleSubmit();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.surfaceDeep,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isSubmitting
                            ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surfaceDeep))
                            : Text(
                                _currentStep < widget.fields.length - 1 ? 'Next Step' : widget.actionLabel,
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ] else
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.surfaceDeep,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isSubmitting
                      ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surfaceDeep))
                      : Text(widget.actionLabel, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
