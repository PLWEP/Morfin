import '../../services/action_context.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/record_metadata.dart';
import 'record_action_wizard_bar.dart';
import 'record_array_field.dart';
import 'record_form_field.dart';

class RecordActionSheet extends StatefulWidget {
  final String title, actionLabel;
  final List<RecordFieldMetadata> fields;
  final Map<String, dynamic> initialValues, paramDefaults;
  final Future<void> Function(Map<String, dynamic> values) onSubmit;
  final String? projection;

  const RecordActionSheet({
    super.key, required this.title, this.actionLabel = 'Submit',
    this.projection, required this.fields, this.initialValues = const {},
    this.paramDefaults = const {}, required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title, String actionLabel = 'Submit', String? projection,
    required List<RecordFieldMetadata> fields, Map<String, dynamic> initialValues = const {},
    Map<String, dynamic> paramDefaults = const {},
    required Future<void> Function(Map<String, dynamic> values) onSubmit,
  }) => showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => RecordActionSheet(
      title: title, actionLabel: actionLabel, projection: projection,
      fields: fields, initialValues: initialValues,
      paramDefaults: paramDefaults, onSubmit: onSubmit,
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
    for (final f in widget.fields) {
      if (!_values.containsKey(f.key) && f.options.isNotEmpty) _values[f.key] = f.options.first;
    }
    final hasBarcode = widget.fields.any((f) =>
        f.type == FieldType.barcode || f.key.toLowerCase().contains('barcode') || f.key.toLowerCase().contains('scancode'));
    _isWizardMode = widget.fields.length >= 2 && hasBarcode;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    for (final f in widget.fields) {
      if (f.type == FieldType.array && f.isRequired) {
        final items = _values[f.key] as List<dynamic>?;
        if (items == null || items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please add at least one item to "${f.label}"'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action failed: $e'), backgroundColor: Colors.red));
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
              if (_isWizardMode && widget.fields.length > 1)
                RecordActionWizardBar(
                  currentStep: _currentStep,
                  totalSteps: widget.fields.length,
                  isWizardMode: _isWizardMode,
                  onToggleMode: () => setState(() => _isWizardMode = !_isWizardMode),
                ),
              ...widget.fields.asMap().entries.map((entry) {
                final idx = entry.key;
                final f = entry.value;
                if (_isWizardMode && idx != _currentStep) return const SizedBox.shrink();

                final res = (f.lovProjection == null || f.lovProjection!.isEmpty)
                    ? (widget.projection != null ? f.copyWith(lovProjection: widget.projection) : f)
                    : f;

                return res.type == FieldType.array
                    ? RecordArrayField(
                        field: res, initialItems: (_values[res.key] as List<dynamic>?) ?? const [],
                        defaultValues: widget.paramDefaults, parentValues: _values,
                        onParentFieldChanged: (k, v) => setState(() => _values[k] = v),
                        onChanged: (v) => setState(() => _values[res.key] = v),
                      )
                    : RecordFormField(
                        key: ValueKey('action_${res.key}'), field: res,
                        initialValue: _values[res.key], contextualValues: _values,
                        onChanged: (v) {
                          _values[res.key] = v;
                          ActionContext.instance.set(res.key, v);
                          if (_isWizardMode && _currentStep < widget.fields.length - 1 && v != null && v.toString().trim().isNotEmpty) {
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted && _currentStep < widget.fields.length - 1) setState(() => _currentStep++);
                            });
                          }
                        },
                        onSaved: (v) => _values[res.key] = v?.trim() ?? '',
                      );
              }),
              const SizedBox(height: 20),
              RecordActionBottomBar(
                isWizardMode: _isWizardMode, currentStep: _currentStep,
                totalSteps: widget.fields.length, isSubmitting: _isSubmitting,
                actionLabel: widget.actionLabel, onBack: () => setState(() => _currentStep--),
                onNextOrSubmit: () {
                  if (_isWizardMode && _currentStep < widget.fields.length - 1) {
                    setState(() => _currentStep++);
                  } else {
                    _handleSubmit();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
