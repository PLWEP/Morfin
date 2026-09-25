import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/app_logo_badge.dart';
import '../../../theme/app_colors.dart';

enum PreviewContext { launcher, splash, login }

class BrandingPreviewCard extends StatefulWidget {
  final String? previewLogo;

  const BrandingPreviewCard({super.key, this.previewLogo});

  @override
  State<BrandingPreviewCard> createState() => _BrandingPreviewCardState();
}

class _BrandingPreviewCardState extends State<BrandingPreviewCard> {
  PreviewContext _selectedContext = PreviewContext.launcher;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        children: [
          // Context Selector Switcher
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                _buildTab('Launcher Icon', PreviewContext.launcher, colors),
                const SizedBox(width: 6),
                _buildTab('Splash Screen', PreviewContext.splash, colors),
                const SizedBox(width: 6),
                _buildTab('Login Header', PreviewContext.login, colors),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Preview Canvas
          Container(
            height: 180,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: BoxDecoration(
              color: colors.surfaceDeep,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: _buildPreviewContent(colors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, PreviewContext ctx, AppPalette colors) {
    final isSelected = _selectedContext == ctx;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedContext = ctx),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryContainer.withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: colors.statusActive.withValues(alpha: 0.5)) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.statusActive : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewContent(AppPalette colors) {
    switch (_selectedContext) {
      case PreviewContext.launcher:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoBadge(size: 80, customLogoOverride: widget.previewLogo),
            const SizedBox(height: 8),
            Text(
              'Morfin Mobile',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.onSurface),
            ),
            Text(
              'Client Edition',
              style: GoogleFonts.inter(fontSize: 10, color: colors.onSurfaceVariant),
            ),
          ],
        );
      case PreviewContext.splash:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoBadge(size: 84, customLogoOverride: widget.previewLogo),
            const SizedBox(height: 16),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primary,
              ),
            ),
          ],
        );
      case PreviewContext.login:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoBadge(size: 64, customLogoOverride: widget.previewLogo),
            const SizedBox(height: 8),
            Text(
              'IFS Cloud Mobile',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: colors.onSurface),
            ),
            Text(
              'Industrial Cloud ERP Suite',
              style: GoogleFonts.inter(fontSize: 10.5, color: colors.onSurfaceVariant),
            ),
          ],
        );
    }
  }
}
