import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../metadata/entity_metadata.dart';
import 'record_array_item_dialog.dart';
import 'record_array_item_tile.dart';

class RecordArrayField extends StatefulWidget {
  final EntityFieldMetadata field;
  final List<dynamic> initialItems;
  final Map<String, dynamic> defaultValues;
  final Map<String, dynamic> parentValues;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  final void Function(String key, dynamic value)? onParentFieldChanged;

  const RecordArrayField({
    super.key,
    required this.field,
    this.initialItems = const [],
    this.defaultValues = const {},
    this.parentValues = const {},
    required this.onChanged,
    this.onParentFieldChanged,
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
    final result = await RecordArrayItemDialog.show(
      context,
      parentField: widget.field,
      existingItem: existingItem,
      defaultValues: widget.defaultValues,
      parentValues: widget.parentValues,
      onParentFieldChanged: widget.onParentFieldChanged,
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

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: colors.surfaceBorder, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.format_list_bulleted_rounded, size: 16, color: colors.primary),
                    const SizedBox(width: 6),
                    Text(
                      widget.field.label,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: colors.onSurface, letterSpacing: 0.2),
                    ),
                    if (widget.field.isRequired)
                      Text(' *', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: colors.statusCritical)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _items.isNotEmpty ? colors.primary.withValues(alpha: 0.15) : colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_items.length}',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _items.isNotEmpty ? colors.primary : colors.outline),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Divider(color: colors.surfaceBorder, thickness: 1)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Line Items', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline)),
              FilledButton.tonalIcon(
                onPressed: () => _openItemDialog(),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Line', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary.withValues(alpha: 0.12),
                  foregroundColor: colors.primary,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surfaceCard.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.6)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.playlist_add_rounded, size: 28, color: colors.outlineVariant),
                  const SizedBox(height: 6),
                  Text('No lines added yet', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: colors.outline)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
              itemBuilder: (ctx, idx) => RecordArrayItemTile(
                index: idx,
                item: _items[idx],
                onEdit: () => _openItemDialog(existingItem: _items[idx], index: idx),
                onDelete: () => _removeItem(idx),
              ),
            ),
        ],
      ),
    );
  }
}
