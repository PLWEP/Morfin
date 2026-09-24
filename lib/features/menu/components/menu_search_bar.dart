import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class MenuSearchBar extends StatelessWidget {
  final ValueChanged<String> onQueryChanged;

  const MenuSearchBar({
    super.key,
    required this.onQueryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: TextField(
        onChanged: onQueryChanged,
        style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search menu, forms...',
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: colors.outline,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
