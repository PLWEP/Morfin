import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../theme/app_colors.dart';
import 'settings_profile_avatar.dart';

class SettingsProfileCard extends ConsumerWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final userAsync = ref.watch(userProfileProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder),
        gradient: LinearGradient(
          colors: [
            colors.primaryContainer.withValues(alpha: 0.12),
            colors.surfaceCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: userAsync.when(
          data: (profile) => _buildContent(colors, profile),
          loading: () => _buildContent(colors, null, isLoading: true),
          error: (err, stack) => _buildContent(colors, null),
        ),
      ),
    );
  }

  Widget _buildContent(AppPalette colors, UserProfile? profile, {bool isLoading = false}) {
    final name = isLoading ? 'Loading profile...' : (profile?.displayName ?? 'IFS User');
    final subtitle = profile?.jobTitle ?? (profile?.personId != null ? 'Person ID: ${profile?.personId}' : 'IFS Cloud User');
    final initials = profile?.initials ?? 'U';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SettingsProfileAvatar(
          initials: initials,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (profile?.email != null) ...[
                const SizedBox(height: 2),
                Text(
                  profile!.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
