import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const SettingsProfileAvatar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Stack(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.statusActive.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Icon(
                Icons.person_rounded,
                size: 32,
                color: colors.statusActive,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors.statusSuccess,
              shape: BoxShape.circle,
              border: Border.all(color: colors.surfaceDeep, width: 2),
              boxShadow: [
                BoxShadow(
                  color: colors.statusSuccess.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
