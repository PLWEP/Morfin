import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../notifications_contract.dart';
import 'critical_telemetry_box.dart';

class CriticalOverheatCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onDismiss;
  final VoidCallback? onMonitor;

  const CriticalOverheatCard({
    super.key,
    required this.item,
    this.onAcknowledge,
    this.onDismiss,
    this.onMonitor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: colors.statusCritical),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(colors),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'Core temperature reached '),
                          TextSpan(
                            text: '114°C',
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.w700,
                              color: colors.statusCritical,
                            ),
                          ),
                          const TextSpan(
                            text: ' (Nominal ceiling: 95°C). Automatic throttling engaged on Sector 02-B substation bus.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CriticalTelemetryBox(
                      sensorId: item.sensorId ?? 'TG-A3-TH09 • Sector 02-B',
                    ),
                    const SizedBox(height: 10),
                    _buildActions(colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppPalette colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.statusCritical.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.statusCritical,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.tag,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.statusCritical,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.timeAgo,
              style: GoogleFonts.jetBrainsMono(fontSize: 10, color: colors.outline),
            ),
          ],
        ),
        InkWell(
          onTap: onDismiss,
          borderRadius: BorderRadius.circular(6),
          child: Icon(Icons.close_rounded, size: 16, color: colors.outline),
        ),
      ],
    );
  }

  Widget _buildActions(AppPalette colors) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onAcknowledge,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: colors.statusCritical,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_rounded, size: 16, color: colors.surfaceDeep),
                  const SizedBox(width: 6),
                  Text(
                    'Acknowledge & Dispatch',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.surfaceDeep,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onMonitor,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.insights_rounded, size: 18, color: colors.statusActive),
          ),
        ),
      ],
    );
  }
}
