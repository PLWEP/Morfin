import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class SettingsTerminalLockCard extends StatelessWidget {
  final VoidCallback? onLockTerminal;

  const SettingsTerminalLockCard({super.key, this.onLockTerminal});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        // About & Compliance Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'IFS CLOUD CORE',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.statusActive,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'v24.2 (Build 8842)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: colors.outline,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.statusSuccess.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'STABLE INDUSTRIAL',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.statusSuccess,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Protected under IFS Enterprise Infrastructure Governance & Zero Trust Architecture standard ISO-27001. All telemetry encrypted in transit and rest.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  height: 1.4,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusActive,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('•', style: TextStyle(color: colors.outline)),
                  ),
                  Text(
                    'Security Audit Log',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusActive,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('•', style: TextStyle(color: colors.outline)),
                  ),
                  Text(
                    'Legal Terms',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusActive,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Danger Button: Lock Terminal
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onLockTerminal,
            icon: Icon(Icons.lock_person_rounded, size: 20, color: colors.statusCritical),
            label: Text(
              'Sign Out / Lock Terminal',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.statusCritical,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.statusCritical.withValues(alpha: 0.08),
              side: BorderSide(color: colors.statusCritical.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 13, color: colors.outline),
            const SizedBox(width: 4),
            Text(
              'Requires re-authentication with smart token on next boot',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: colors.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
