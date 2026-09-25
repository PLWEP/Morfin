import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/activity_log_service.dart';
import '../../../theme/app_colors.dart';

class ActivityLogItemTile extends StatelessWidget {
  final ActivityLogEntry entry;

  const ActivityLogItemTile({super.key, required this.entry});

  Color _levelColor(LogLevel level, AppPalette colors) {
    return switch (level) {
      LogLevel.error => colors.statusCritical,
      LogLevel.warning => colors.statusWarning,
      LogLevel.network => colors.statusActive,
      LogLevel.info => colors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final color = _levelColor(entry.level, colors);
    final timeStr = entry.timestamp.toLocal().toString().substring(11, 19);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.level.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeStr,
                style: GoogleFonts.inter(fontSize: 11, color: colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            entry.message,
            style: GoogleFonts.inter(fontSize: 12, color: colors.onSurface),
          ),
          if (entry.details != null && entry.details!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              entry.details!,
              style: GoogleFonts.inter(fontSize: 11, color: colors.statusCritical),
            ),
          ],
        ],
      ),
    );
  }
}
