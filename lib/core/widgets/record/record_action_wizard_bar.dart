import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class RecordActionWizardBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isWizardMode;
  final VoidCallback onToggleMode;

  const RecordActionWizardBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isWizardMode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: colors.onPrimaryContainer),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              icon: Icon(isWizardMode ? Icons.view_agenda_rounded : Icons.linear_scale_rounded, size: 16),
              label: Text(isWizardMode ? 'View All' : 'Wizard', style: GoogleFonts.inter(fontSize: 12)),
              onPressed: onToggleMode,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (currentStep + 1) / totalSteps,
          backgroundColor: colors.surfaceContainerHigh,
          color: colors.primary,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class RecordActionBottomBar extends StatelessWidget {
  final bool isWizardMode;
  final int currentStep;
  final int totalSteps;
  final bool isSubmitting;
  final String actionLabel;
  final VoidCallback onBack;
  final VoidCallback onNextOrSubmit;

  const RecordActionBottomBar({
    super.key,
    required this.isWizardMode,
    required this.currentStep,
    required this.totalSteps,
    required this.isSubmitting,
    required this.actionLabel,
    required this.onBack,
    required this.onNextOrSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    if (isWizardMode && totalSteps > 1) {
      return Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Back', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onNextOrSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.surfaceDeep,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isSubmitting
                  ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surfaceDeep))
                  : Text(
                      currentStep < totalSteps - 1 ? 'Next Step' : actionLabel,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: isSubmitting ? null : onNextOrSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.surfaceDeep,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isSubmitting
          ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colors.surfaceDeep))
          : Text(actionLabel, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
