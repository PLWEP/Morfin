import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class BrandingQualityGuideCard extends StatelessWidget {
  const BrandingQualityGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final guidelines = const [
      (
        icon: Icons.aspect_ratio_rounded,
        title: 'Dimensi & Rasio',
        desc: 'Ideal 512 x 512 px (Rasio 1:1 square/persegi)',
      ),
      (
        icon: Icons.layers_clear_rounded,
        title: 'Format File',
        desc: 'PNG Transparan (32-bit RGBA) atau WebP',
      ),
      (
        icon: Icons.crop_free_rounded,
        title: 'Safe Margin',
        desc: 'Sisakan padding 15–20% dari tepi agar tidak terpotong sudut squircle',
      ),
      (
        icon: Icons.contrast_rounded,
        title: 'Kontras Warna',
        desc: 'Gunakan logo yang kontras tinggi di tema gelap & terang',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: colors.statusActive),
              const SizedBox(width: 6),
              Text(
                'Panduan Kualitas Gambar Terbaik',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...guidelines.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(g.icon, size: 14, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 11.5, color: colors.onSurfaceVariant),
                        children: [
                          TextSpan(
                            text: '${g.title}: ',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: colors.onSurface),
                          ),
                          TextSpan(text: g.desc),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
