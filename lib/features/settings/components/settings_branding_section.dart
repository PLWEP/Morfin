import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/branding_provider.dart';
import '../../../core/widgets/app_logo_badge.dart';
import '../../../theme/app_colors.dart';
import '../branding_screen.dart';
import 'industrial_setting_tile.dart';

class SettingsBrandingSection extends ConsumerWidget {
  const SettingsBrandingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final customLogo = ref.watch(customLogoProvider);
    final hasCustom = customLogo != null && customLogo.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.palette_rounded, size: 16, color: colors.statusActive),
              const SizedBox(width: 6),
              Text(
                'Corporate Branding',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: IndustrialSettingTile(
            icon: Icons.branding_watermark_rounded,
            iconColor: colors.primary,
            title: 'Client App Logo',
            subtitle: hasCustom ? 'Custom company logo active' : 'Morfin default • Tap to customize',
            trailing: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BrandingScreen()),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogoBadge(size: 18),
                    const SizedBox(width: 6),
                    Text(
                      hasCustom ? 'Change' : 'Customize',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
