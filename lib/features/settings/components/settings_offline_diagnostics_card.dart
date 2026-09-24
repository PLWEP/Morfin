import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class SettingsOfflineDiagnosticsCard extends StatelessWidget {
  final VoidCallback? onSyncNow;

  const SettingsOfflineDiagnosticsCard({super.key, this.onSyncNow});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.statusSuccess,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.statusSuccess.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Offline Mode: Ready',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onSyncNow,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync_rounded,
                          size: 15, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        'Sync Now',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStatBox(
                context,
                title: 'Pending Sync',
                value: '0 items',
                valueColor: colors.statusActive,
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                context,
                title: 'Last Sync',
                value: '12:44:09',
                valueColor: colors.onSurface,
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                context,
                title: 'Cache Size',
                value: '18.4 MB',
                valueColor: colors.statusSuccess,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    final colors = AppColors.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: colors.outline,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
