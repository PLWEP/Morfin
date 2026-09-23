import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class AddServerFormFields extends StatelessWidget {
  final TextEditingController aliasController;
  final TextEditingController urlController;
  final TextEditingController realmController;

  const AddServerFormFields({
    super.key,
    required this.aliasController,
    required this.urlController,
    required this.realmController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENVIRONMENT ALIAS',
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
            hintText: 'e.g. IFS Cloud Jakarta Hub',
            prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
          ),
          validator: (val) =>
              (val == null || val.trim().isEmpty) ? 'Please enter alias' : null,
        ),
        const SizedBox(height: 14),
        Text(
          'ENDPOINT URL',
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
            hintText: 'https://ifs.internal.company.com',
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
          'SYSTEM REALM / ID',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: realmController,
          style: GoogleFonts.jetBrainsMono(fontSize: 13, color: colors.onSurface),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.vpn_key_outlined, size: 20),
          ),
        ),
      ],
    );
  }
}
