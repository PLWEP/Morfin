import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class ModuleInfoSheet {
  const ModuleInfoSheet._();

  static void show(
    BuildContext context, {
    required String title,
    required String projection,
    String? entitySet,
    String? client,
  }) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.hub_outlined, color: colors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          'Web Projection (Desktop)',
                          style: GoogleFonts.inter(fontSize: 12, color: colors.outline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.surfaceBorder),
                ),
                child: Column(
                  children: [
                    _infoRow('Projection', projection, colors),
                    if (entitySet != null && entitySet.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _infoRow('EntitySet', entitySet, colors),
                    ],
                    if (client != null && client.isNotEmpty && client != projection) ...[
                      const SizedBox(height: 6),
                      _infoRow('Client', client, colors),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This projection is not yet mobilized into the mobile SDUI schema.',
                style: GoogleFonts.inter(fontSize: 12, color: colors.outline),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.surfaceBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(color: colors.onSurface, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String value, AppPalette colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: colors.outline, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.robotoMono(fontSize: 11, color: colors.onSurface, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
