import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class CriticalCardActions extends StatelessWidget {
  final VoidCallback? onAcknowledge;
  final VoidCallback? onMonitor;

  const CriticalCardActions({
    super.key,
    this.onAcknowledge,
    this.onMonitor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

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
