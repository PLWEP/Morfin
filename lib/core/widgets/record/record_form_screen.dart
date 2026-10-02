import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../services/backend_service.dart';
import '../../utils/payload_utils.dart';
import 'record_array_field.dart';
import 'record_form_field.dart';

class RecordFormScreen extends StatefulWidget {
  final String title;
  final String projection;
  final String actionName;
  final List<EntityFieldMetadata> fields;
  final List<EntityFieldMetadata> allFieldDefinitions;
  final Map<String, dynamic> paramDefaults;
  final Map<String, dynamic> initialValues;
  final VoidCallback onRefresh;

  const RecordFormScreen({
    super.key,
    required this.title,
    required this.projection,
    required this.actionName,
    required this.fields,
    this.allFieldDefinitions = const [],
    this.paramDefaults = const {},
    this.initialValues = const {},
    required this.onRefresh,
  });

  @override
  State<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends State<RecordFormScreen> {
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

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);
    try {
      final effectiveDefs = widget.allFieldDefinitions.isNotEmpty ? widget.allFieldDefinitions : widget.fields;
      final payload = PayloadUtils.formatActionPayload(
        rawValues: _values,
        allFieldDefs: effectiveDefs,
        defaultValues: widget.paramDefaults,
      );
      await BackendService.instance.executeAction(
        projection: widget.projection,
        actionName: widget.actionName,
        parameters: payload,
      );

      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('"${widget.title}" submitted successfully'), behavior: SnackBarBehavior.floating));
        widget.onRefresh();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errorMsg = PayloadUtils.extractErrorMessage(e);
        messenger.showSnackBar(SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        title: Text(widget.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.fields.map((f) {
                        final resolved = (f.lovProjection == null || f.lovProjection!.isEmpty)
                            ? f.copyWith(lovProjection: widget.projection)
                            : f;

                        return resolved.type == FieldType.array
                            ? RecordArrayField(
                                field: resolved,
                                initialItems: (_values[resolved.key] as List<dynamic>?) ?? const [],
                                defaultValues: widget.paramDefaults,
                                parentValues: _values,
                                onChanged: (val) => setState(() => _values[resolved.key] = val),
                              )
                            : RecordFormField(
                                field: resolved,
                                initialValue: _values[resolved.key],
                                contextualValues: _values,
                                onChanged: (val) => setState(() => _values[resolved.key] = val),
                                onSaved: (val) => _values[resolved.key] = val?.trim() ?? '',
                              );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: colors.surfaceCard, border: Border(top: BorderSide(color: colors.surfaceBorder))),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.surfaceDeep,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Submit', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
