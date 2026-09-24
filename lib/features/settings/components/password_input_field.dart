import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PasswordInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String? Function(String?) validator;

  const PasswordInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggleObscure,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: GoogleFonts.inter(fontSize: 14, color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: colors.onSurfaceVariant),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 19,
                color: colors.onSurfaceVariant,
              ),
              onPressed: onToggleObscure,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
