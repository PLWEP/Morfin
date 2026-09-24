import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../work_order_contract.dart';

class CreateWorkOrderSheet extends StatefulWidget {
  final void Function({
    required String title,
    required String assetName,
    required String location,
    required WorkOrderPriority priority,
    required String dueDate,
    required String description,
  }) onCreated;

  const CreateWorkOrderSheet({super.key, required this.onCreated});

  @override
  State<CreateWorkOrderSheet> createState() => _CreateWorkOrderSheetState();
}

class _CreateWorkOrderSheetState extends State<CreateWorkOrderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _assetController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  WorkOrderPriority _priority = WorkOrderPriority.medium;
  final String _dueDate = 'Today, 18:00';

  @override
  void dispose() {
    _titleController.dispose();
    _assetController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCreated(
      title: _titleController.text.trim(),
      assetName: _assetController.text.trim(),
      location: _locationController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
      description: _descriptionController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: colors.surfaceBorder)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New Work Order', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: colors.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField('Issue Title', 'e.g. Bearing noise inspection', _titleController, colors),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField('Asset Name', 'e.g. Robot Cell 03', _assetController, colors)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField('Location', 'e.g. Bay 4 - Line 2', _locationController, colors)),
                ],
              ),
              const SizedBox(height: 12),
              Text('Priority', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
              const SizedBox(height: 6),
              _buildPrioritySelector(colors),
              const SizedBox(height: 12),
              _buildTextField('Instructions', 'Describe the diagnostic steps...', _descriptionController, colors, maxLines: 2),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Create Ticket', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, AppPalette colors, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.onSurface)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant),
            filled: true,
            fillColor: colors.surfaceCard,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.surfaceBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector(AppPalette colors) {
    return Row(
      children: WorkOrderPriority.values.map((p) {
        final isSelected = _priority == p;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(p.label),
            selected: isSelected,
            onSelected: (_) => setState(() => _priority = p),
            selectedColor: colors.primary,
            backgroundColor: colors.surfaceCard,
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : colors.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}
