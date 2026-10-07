import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class RecordStatusBadge extends StatelessWidget {
  final String status;

  const RecordStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status.isEmpty) return const SizedBox.shrink();
    final colors = AppColors.of(context);
    final (bg, fg) = _resolveColors(status, colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.5),
      ),
    );
  }

  (Color, Color) _resolveColors(String s, AppPalette colors) {
    final lower = s.toLowerCase();
    if (lower.contains('progress') || lower.contains('active')) return (colors.statusActive.withValues(alpha: 0.12), colors.statusActive);
    if (lower.contains('pending') || lower.contains('low') || lower.contains('warn')) return (colors.statusWarning.withValues(alpha: 0.12), colors.statusWarning);
    if (lower.contains('crit') || lower.contains('out') || lower.contains('error')) return (colors.statusCritical.withValues(alpha: 0.12), colors.statusCritical);
    if (lower.contains('done') || lower.contains('complete') || lower.contains('in stock')) return (colors.statusSuccess.withValues(alpha: 0.12), colors.statusSuccess);
    return (colors.surfaceContainerHigh, colors.outline);
  }
}
