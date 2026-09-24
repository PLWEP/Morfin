import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class WorkOrderSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const WorkOrderSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search tickets, code, asset...',
          hintStyle: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceVariant),
          prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.onSurfaceVariant),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, size: 16, color: colors.onSurfaceVariant),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
