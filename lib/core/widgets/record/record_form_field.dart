import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/record_metadata.dart';
import '../../services/industrial_feedback_service.dart';
import '../../storage/local_storage_service.dart';
import 'barcode_scanner_sheet.dart';
import 'record_lookup_sheet.dart';

class RecordFormField extends StatefulWidget {
  final RecordFieldMetadata field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final FormFieldSetter<String> onSaved;
  final String? contextFilter;
  final Map<String, dynamic> contextualValues;
  final void Function(Map<String, dynamic> record)? onFullRecordSelected;

  const RecordFormField({
    super.key,
    required this.field,
    this.initialValue,
    required this.onChanged,
    required this.onSaved,
    this.contextFilter,
    this.contextualValues = const {},
    this.onFullRecordSelected,
  });

  @override
  State<RecordFormField> createState() => _RecordFormFieldState();
}

class _RecordFormFieldState extends State<RecordFormField> {
  late final TextEditingController _controller;
  String? _selectedValue;
  bool _isIndustrialMode = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue?.toString();
    _controller = TextEditingController(text: _selectedValue ?? '');
    _checkIndustrialMode();
  }

  void _checkIndustrialMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) setState(() => _isIndustrialMode = LocalStorageService(prefs).getIndustrialMode());
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant RecordFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      final newVal = widget.initialValue?.toString() ?? '';
      if (_controller.text != newVal && !FocusScope.of(context).hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _controller.text != newVal && !FocusScope.of(context).hasFocus) {
            _controller.text = newVal;
          }
        });
        _selectedValue = widget.initialValue?.toString();
      }
    }
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
      contextFilter: widget.contextFilter,
      targetFieldKey: widget.field.key,
      contextualValues: widget.contextualValues,
      onFullRecordSelected: widget.onFullRecordSelected,
      onRecordSelected: (code, display) {
        setState(() {
          _selectedValue = code;
          _controller.text = display;
        });
        widget.onChanged(code);
      },
      onSelected: (val) {
        setState(() {
          _selectedValue = val;
          _controller.text = val;
        });
        widget.onChanged(val);
      },
    );
  }

  Future<void> _scanBarcode() async {
    final code = await BarcodeScannerSheet.scan(
      context,
      title: 'Scan ${widget.field.label}',
      subtitle: 'Align barcode within frame',
    );
    if (code != null && code.isNotEmpty) {
      setState(() {
        _controller.text = code;
        _selectedValue = code;
      });
      widget.onChanged(code);
    }
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
    final isBarcode = widget.field.type == FieldType.barcode ||
        widget.field.key.toLowerCase().contains('barcode') ||
        widget.field.key.toLowerCase().contains('scancode');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controller,
        readOnly: hasLov,
        onTap: hasLov ? _openLov : null,
        keyboardType: isNum ? TextInputType.number : (isBarcode && _isIndustrialMode) ? TextInputType.none : TextInputType.text,
        style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
        decoration: _decoration(
          colors,
          suffixIcon: isBarcode
              ? IconButton(icon: Icon(Icons.qr_code_scanner_rounded, size: 20, color: colors.statusActive), tooltip: 'Scan Barcode', onPressed: _scanBarcode)
              : hasLov ? IconButton(icon: const Icon(Icons.arrow_drop_down_circle_outlined, size: 18), onPressed: _openLov) : null,
        ),
        validator: widget.field.isRequired ? (val) => (val == null || val.trim().isEmpty) ? '${widget.field.label} is required' : null : null,
        onChanged: widget.onChanged,
        onFieldSubmitted: (val) {
          if (isBarcode) IndustrialFeedbackService.instance.playScan();
          widget.onChanged(val);
        },
        onSaved: (val) => widget.onSaved(hasLov && _selectedValue != null ? _selectedValue : (val?.trim() ?? '')),
      ),
    );
  }

  InputDecoration _decoration(AppPalette colors, {Widget? suffixIcon}) {
    final b = OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.surfaceBorder));
    return InputDecoration(
      labelText: widget.field.isRequired ? '${widget.field.label} *' : widget.field.label,
      labelStyle: GoogleFonts.inter(fontSize: 12, color: colors.outline),
      filled: true, fillColor: colors.surfaceCard, enabledBorder: b,
      focusedBorder: b.copyWith(borderSide: BorderSide(color: colors.primary, width: 1.5)),
      errorBorder: b.copyWith(borderSide: BorderSide(color: colors.statusCritical)),
      focusedErrorBorder: b.copyWith(borderSide: BorderSide(color: colors.statusCritical, width: 1.5)),
      suffixIcon: suffixIcon,
    );
  }
}
