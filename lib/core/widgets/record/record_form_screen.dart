import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import '../../services/backend_service.dart';
import '../../utils/payload_utils.dart';
import 'record_array_field.dart';
import 'record_form_discard_dialog.dart';
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
  late final Map<String, dynamic> _initialSnapshot;
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
    _initialSnapshot = Map<String, dynamic>.from(_values);
  }

  bool get _isDirty => RecordFormDiscardDialog.isDirty(current: _values, initial: _initialSnapshot);

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
    final nav = Navigator.of(context);
    final cardColor = AppColors.of(context).surfaceCard;
    setState(() => _isSubmitting = true);
    try {
      final effectiveDefs = widget.allFieldDefinitions.isNotEmpty ? widget.allFieldDefinitions : widget.fields;
      final payload = PayloadUtils.formatActionPayload(rawValues: _values, allFieldDefs: effectiveDefs, defaultValues: widget.paramDefaults);
      final response = await BackendService.instance.executeAction(projection: widget.projection, actionName: widget.actionName, parameters: payload);

      if (mounted) {
        final successMsg = PayloadUtils.extractSuccessMessage(response, fallback: '"${widget.title}" submitted successfully');
        messenger.showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(successMsg, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500))),
            ]),
            backgroundColor: cardColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        widget.onRefresh();
        nav.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        messenger.showSnackBar(SnackBar(content: Text('Error: ${PayloadUtils.extractErrorMessage(e)}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    }
  }

  Widget _buildFieldItem(EntityFieldMetadata f) {
    final resolved = (f.lovProjection == null || f.lovProjection!.isEmpty) ? f.copyWith(lovProjection: widget.projection) : f;
    return resolved.type == FieldType.array
        ? RecordArrayField(
            field: resolved,
            initialItems: (_values[resolved.key] as List<dynamic>?) ?? const [],
            defaultValues: widget.paramDefaults,
            parentValues: _values,
            onParentFieldChanged: (k, v) => setState(() => _values[k] = v),
            onChanged: (val) => setState(() => _values[resolved.key] = val),
          )
        : RecordFormField(
            key: ValueKey('header_${resolved.key}'),
            field: resolved,
            initialValue: _values[resolved.key],
            contextualValues: _values,
            onChanged: (val) => setState(() => _values[resolved.key] = val),
            onSaved: (val) => _values[resolved.key] = val?.trim() ?? '',
          );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final nav = Navigator.of(context);
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await RecordFormDiscardDialog.confirm(context) && mounted) nav.pop();
      },
      child: Scaffold(
        backgroundColor: colors.surfaceDeep,
        appBar: AppBar(
          backgroundColor: colors.surfaceCard,
          elevation: 0,
          title: Text(widget.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: colors.onSurface),
            onPressed: () async {
              if (await RecordFormDiscardDialog.confirm(context) && mounted) nav.pop();
            },
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
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...widget.fields.map(_buildFieldItem), const SizedBox(height: 24)]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(color: colors.surfaceCard, border: Border(top: BorderSide(color: colors.surfaceBorder))),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.surfaceDeep, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
      ),
    );
  }
}
