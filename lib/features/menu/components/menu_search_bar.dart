import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class MenuSearchBar extends StatelessWidget {
  final ValueChanged<String> onQueryChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onRfidScan;

  const MenuSearchBar({
    super.key,
    required this.onQueryChanged,
    this.onVoiceSearch,
    this.onRfidScan,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.manage_search_rounded,
              color: colors.statusActive,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onQueryChanged,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search IFS modules, workflows, forms...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.mic_none_rounded,
              color: colors.onSurfaceVariant,
              size: 20,
            ),
            tooltip: 'Voice Command',
            onPressed: onVoiceSearch ?? () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: onRfidScan ?? () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: colors.statusActive,
                  size: 19,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
