import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const _presets = [
    (name: 'Acme Corp', url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=256&auto=format&fit=crop&q=80'),
    (name: 'Apex Energy', url: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=256&auto=format&fit=crop&q=80'),
    (name: 'Nordic Tech', url: 'https://images.unsplash.com/photo-1614680376593-902f749f7ffc?w=256&auto=format&fit=crop&q=80'),
  ];

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

  void _applyLogo() {
    final val = _controller.text.trim();
    if (val.isEmpty) return;
    ref.read(customLogoProvider.notifier).setCustomLogo(val);
    _showFeedback('Client logo applied successfully');
    Navigator.of(context).pop();
  }

  void _resetDefault() {
    ref.read(customLogoProvider.notifier).resetToDefault();
    _controller.clear();
    setState(() => _previewLogo = null);
    _showFeedback('Reverted to default Morfin logo');
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
        title: Text('Client App Logo & Branding', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: colors.onSurface)),
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
              Text('LOGO SOURCE (URL / FILE PATH / BASE64)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                style: GoogleFonts.inter(fontSize: 13, color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'https://company.com/logo.png',
                  hintStyle: GoogleFonts.inter(fontSize: 12, color: colors.onSurfaceMuted),
                  filled: true,
                  fillColor: colors.surfaceCard,
                  prefixIcon: Icon(Icons.link_rounded, size: 18, color: colors.primary),
                  suffixIcon: _controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () => _controller.clear()) : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.surfaceBorder)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Presets: ', style: GoogleFonts.inter(fontSize: 11.5, color: colors.onSurfaceVariant)),
                    ..._presets.map((p) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ActionChip(label: Text(p.name, style: GoogleFonts.inter(fontSize: 11)), onPressed: () => _controller.text = p.url, backgroundColor: colors.surfaceContainerLow),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const BrandingQualityGuideCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (hasCustom || _previewLogo != null) ...[
                    OutlinedButton(onPressed: _resetDefault, style: OutlinedButton.styleFrom(foregroundColor: colors.statusCritical, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)), child: const Text('Reset')),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _previewLogo != null ? _applyLogo : null,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Save & Apply Logo'),
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
