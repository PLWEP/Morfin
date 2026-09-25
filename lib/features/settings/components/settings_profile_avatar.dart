import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class SettingsProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;

  const SettingsProfileAvatar({
    super.key,
    this.imageUrl,
    this.initials = 'U',
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.statusActive.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => _buildInitials(colors),
              ),
            )
          : _buildInitials(colors),
    );
  }

  Widget _buildInitials(AppPalette colors) {
    return Text(
      initials,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colors.primary,
      ),
    );
  }
}
