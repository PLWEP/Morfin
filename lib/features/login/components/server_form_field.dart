import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class ServerFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isMono;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const ServerFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isMono = false,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: isMono
              ? GoogleFonts.jetBrainsMono(fontSize: 13, color: colors.onSurface)
              : GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: colors.onSurfaceVariant),
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
