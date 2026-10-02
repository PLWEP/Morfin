import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class RecordFormDiscardDialog {
  const RecordFormDiscardDialog._();

  static bool isDirty({
    required Map<String, dynamic> current,
    required Map<String, dynamic> initial,
  }) {
    for (final entry in current.entries) {
      final initVal = initial[entry.key];
      final curVal = entry.value;
      if (curVal is List && curVal.isNotEmpty) return true;
      if (curVal is String && curVal.trim().isNotEmpty && curVal != initVal) return true;
      if (curVal != null && curVal != initVal && curVal is! List && curVal is! String) return true;
    }
    return current.keys.length > initial.keys.length;
  }

  static Future<bool> confirm(BuildContext context) async {
    final colors = AppColors.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Batalkan Perubahan?',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface),
        ),
        content: Text(
          'Data yang sudah dimasukkan akan hilang jika Anda keluar dari form ini.',
          style: GoogleFonts.inter(fontSize: 14, color: colors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text('Tetap di Sini', style: GoogleFonts.inter(color: colors.primary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Keluar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    return discard ?? false;
  }
}
