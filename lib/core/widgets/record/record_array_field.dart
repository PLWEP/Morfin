import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_form_field.dart';

class RecordArrayField extends StatefulWidget {
  final EntityFieldMetadata field;
  final List<dynamic> initialItems;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const RecordArrayField({
    super.key,
    required this.field,
    this.initialItems = const [],
    required this.onChanged,
  });

  @override
  State<RecordArrayField> createState() => _RecordArrayFieldState();
}

class _RecordArrayFieldState extends State<RecordArrayField> {
  final List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    for (final it in widget.initialItems) {
      if (it is Map<String, dynamic>) {
        _items.add(Map<String, dynamic>.from(it));
      } else if (it is Map) {
        _items.add(Map<String, dynamic>.from(it));
      }
    }
  }

  void _openItemDialog({Map<String, dynamic>? existingItem, int? index}) async {
    final colors = AppColors.of(context);
    final formKey = GlobalKey<FormState>();
    final draft = Map<String, dynamic>.from(existingItem ?? {});

    final subFields = widget.field.nestedFields.isNotEmpty
        ? widget.field.nestedFields
        : [
            const EntityFieldMetadata(key: 'PartNo', label: 'Part No'),
            const EntityFieldMetadata(key: 'Description', label: 'Description'),
            const EntityFieldMetadata(key: 'Quantity', label: 'Quantity', type: FieldType.number, isRequired: true),
            const EntityFieldMetadata(key: 'UnitMeasure', label: 'Unit of Measure'),
            const EntityFieldMetadata(key: 'Price', label: 'Price', type: FieldType.number),
            const EntityFieldMetadata(key: 'CurrencyCode', label: 'Currency'),
          ];

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets.bottom;
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
                      Navigator.of(ctx).pop(draft);
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
      },
    );

    if (result != null) {
      setState(() {
        if (index != null && index >= 0 && index < _items.length) {
          _items[index] = result;
        } else {
          _items.add(result);
        }
      });
      widget.onChanged(List.from(_items));
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    widget.onChanged(List.from(_items));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.field.label} (${_items.length})',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => _openItemDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Line', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No items added yet. Click "+ Add Line" to add.',
                  style: GoogleFonts.inter(fontSize: 12, color: colors.outline),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 6),
              itemBuilder: (ctx, idx) {
                final it = _items[idx];
                final primary = it['PartNo'] ?? it['Description'] ?? 'Item #${idx + 1}';
                final qty = it['Quantity'] != null ? 'Qty: ${it['Quantity']}' : '';
                final uom = it['UnitMeasure'] ?? '';
                final subtitle = [qty, uom].where((s) => s.isNotEmpty).join(' ');

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surfaceDeep,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              primary.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                            if (subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                style: GoogleFonts.inter(fontSize: 11, color: colors.outline),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        color: colors.outline,
                        onPressed: () => _openItemDialog(existingItem: it, index: idx),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 16),
                        color: colors.statusCritical,
                        onPressed: () => _removeItem(idx),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
