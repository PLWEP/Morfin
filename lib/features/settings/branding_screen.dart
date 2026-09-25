import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/branding_provider.dart';
import '../../theme/app_colors.dart';
import 'components/branding_preview_card.dart';
import 'components/branding_quality_guide_card.dart';

class BrandingScreen extends ConsumerStatefulWidget {
  const BrandingScreen({super.key});

  @override
  ConsumerState<BrandingScreen> createState() => _BrandingScreenState();
}

class _BrandingScreenState extends ConsumerState<BrandingScreen> {
  late final TextEditingController _controller;
  String? _previewLogo;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final current = ref.read(customLogoProvider);
    _controller = TextEditingController(text: current ?? '');
    _previewLogo = current;
    _controller.addListener(() {
      setState(() {
        _previewLogo = _controller.text.trim().isNotEmpty ? _controller.text.trim() : null;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      setState(() => _isUploading = true);
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 92,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        final ext = picked.path.split('.').last.toLowerCase();
        final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
        final base64Data = 'data:$mime;base64,${base64Encode(bytes)}';
        _controller.text = base64Data;
        setState(() => _previewLogo = base64Data);
        _showFeedback('Logo berhasil dimuat ke preview');
      }
    } catch (e) {
      _showFeedback('Gagal memuat gambar: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _applyLogo() {
    final val = _controller.text.trim();
    if (val.isEmpty) return;
    ref.read(customLogoProvider.notifier).setCustomLogo(val);
    _showFeedback('Logo perusahaan berhasil diterapkan');
    Navigator.of(context).pop();
  }

  void _resetDefault() {
    ref.read(customLogoProvider.notifier).resetToDefault();
    _controller.clear();
    setState(() => _previewLogo = null);
    _showFeedback('Kembali ke logo bawaan Morfin');
  }

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.inter(fontSize: 13)), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasCustom = ref.watch(customLogoProvider) != null;

    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        title: Text('Kustomisasi Logo Perusahaan', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LIVE PREVIEW MOCKUP', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              BrandingPreviewCard(previewLogo: _previewLogo),
              const SizedBox(height: 16),
              Text('OPSI 1: UPLOAD DARI PERANGKAT', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isUploading ? null : _pickImage,
                  icon: _isUploading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(Icons.add_photo_alternate_rounded, size: 18, color: colors.primary),
                  label: Text(_isUploading ? 'Memproses gambar...' : 'Pilih Gambar dari Galeri / File', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: colors.primary.withValues(alpha: 0.6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('OPSI 2: ATAU MASUKKAN URL GAMBAR', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'https://perusahaan.com/logo.png',
                  hintStyle: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceMuted),
                  filled: true,
                  fillColor: colors.surfaceCard,
                  prefixIcon: Icon(Icons.link_rounded, size: 18, color: colors.primary),
                  suffixIcon: _controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () => _controller.clear()) : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.surfaceBorder)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),
              const BrandingQualityGuideCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (hasCustom || _previewLogo != null) ...[
                    OutlinedButton(onPressed: _resetDefault, style: OutlinedButton.styleFrom(foregroundColor: colors.statusCritical, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)), child: const Text('Reset Default')),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _previewLogo != null ? _applyLogo : null,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Simpan & Terapkan Logo'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
