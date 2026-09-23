import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../menu_contract.dart';

class ModuleListTile extends StatelessWidget {
  final ModuleItem module;
  final VoidCallback? onTap;

  const ModuleListTile({
    super.key,
    required this.module,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.surfaceBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                module.icon,
                color: _iconColor(module.badgeType, colors),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          module.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      if (module.badgeText != null) ...[
                        const SizedBox(width: 6),
                        _buildBadge(module, colors),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(ModuleItem module, AppPalette colors) {
    final (bg, fg) = switch (module.badgeType) {
      ModuleBadgeType.active => (
          colors.statusActive.withValues(alpha: 0.18),
          colors.statusActive
        ),
      ModuleBadgeType.success => (
          colors.statusSuccess.withValues(alpha: 0.18),
          colors.statusSuccess
        ),
      ModuleBadgeType.warning => (
          colors.statusWarning.withValues(alpha: 0.18),
          colors.statusWarning
        ),
      ModuleBadgeType.critical => (
          colors.statusCritical.withValues(alpha: 0.18),
          colors.statusCritical
        ),
      ModuleBadgeType.hardware => (
          colors.surfaceContainerHigh,
          colors.statusActive
        ),
      _ => (colors.primaryContainer.withValues(alpha: 0.2), colors.statusActive),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        module.badgeText!,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Color _iconColor(ModuleBadgeType type, AppPalette colors) {
    return switch (type) {
      ModuleBadgeType.active => colors.statusActive,
      ModuleBadgeType.success => colors.statusSuccess,
      ModuleBadgeType.warning => colors.statusWarning,
      ModuleBadgeType.critical => colors.statusCritical,
      _ => colors.statusActive,
    };
  }
}
