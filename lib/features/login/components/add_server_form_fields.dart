import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class AddServerFormFields extends StatelessWidget {
  final TextEditingController aliasController;
  final TextEditingController urlController;
  final String selectedEnvType;
  final ValueChanged<String> onEnvTypeChanged;
  final bool useSsl;
  final ValueChanged<bool> onSslChanged;

  const AddServerFormFields({
    super.key,
    required this.aliasController,
    required this.urlController,
    required this.selectedEnvType,
    required this.onEnvTypeChanged,
    required this.useSsl,
    required this.onSslChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVER NAME / ALIAS',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: aliasController,
          style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
          decoration: const InputDecoration(
            hintText: 'e.g. IFS Cloud Staging EMEA',
            prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
          ),
          validator: (val) =>
              (val == null || val.trim().isEmpty) ? 'Please enter server name' : null,
        ),
        const SizedBox(height: 14),
        Text(
          'SERVER URL / HOST ENDPOINT',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: urlController,
          style: GoogleFonts.jetBrainsMono(fontSize: 13, color: colors.onSurface),
          decoration: const InputDecoration(
            hintText: 'https://cloud-emea.ifs.com',
            prefixIcon: Icon(Icons.link_rounded, size: 20),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return 'Please enter server URL';
            if (!val.startsWith('http://') && !val.startsWith('https://')) {
              return 'URL must start with http:// or https://';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        Text(
          'ENVIRONMENT TYPE',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildEnvButton(context, 'Production'),
            const SizedBox(width: 8),
            _buildEnvButton(context, 'Staging'),
            const SizedBox(width: 8),
            _buildEnvButton(context, 'Development'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use Secure Connection (SSL/TLS)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'Port 443 with HTTPS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.outline.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: useSsl,
                onChanged: onSslChanged,
                activeThumbColor: colors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnvButton(BuildContext context, String title) {
    final colors = AppColors.of(context);
    final isSelected = selectedEnvType == title;

    return Expanded(
      child: InkWell(
        onTap: () => onEnvTypeChanged(title),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.12)
                : colors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colors.primary : colors.surfaceBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
