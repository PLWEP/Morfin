import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../theme/app_colors.dart';
import '../../services/industrial_feedback_service.dart';

class BarcodeScannerSheet extends StatefulWidget {
  final String title;
  final String? subtitle;

  const BarcodeScannerSheet({super.key, required this.title, this.subtitle});

  static Future<String?> scan(BuildContext context, {required String title, String? subtitle}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BarcodeScannerSheet(title: title, subtitle: subtitle),
    );
  }

  @override
  State<BarcodeScannerSheet> createState() => _BarcodeScannerSheetState();
}

class _BarcodeScannerSheetState extends State<BarcodeScannerSheet> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  final _manualController = TextEditingController();
  bool _isTorchOn = false;
  bool _hasDetected = false;

  @override
  void dispose() {
    _controller.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasDetected) return;
    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue ?? barcode.displayValue;
      if (code != null && code.trim().isNotEmpty) {
        _hasDetected = true;
        IndustrialFeedbackService.instance.playScan();
        Navigator.of(context).pop(code.trim());
        break;
      }
    }
  }

  void _submitManual() {
    final text = _manualController.text.trim();
    if (text.isNotEmpty) {
      _hasDetected = true;
      IndustrialFeedbackService.instance.playScan();
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.85,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: colors.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colors.onSurface)),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(widget.subtitle!, style: GoogleFonts.inter(fontSize: 13, color: colors.onSurfaceMuted)),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded),
                  color: _isTorchOn ? colors.statusWarning : colors.onSurfaceMuted,
                  onPressed: () { _controller.toggleTorch(); setState(() => _isTorchOn = !_isTorchOn); },
                ),
                IconButton(icon: Icon(Icons.flip_camera_ios_rounded, color: colors.onSurfaceVariant), onPressed: () => _controller.switchCamera()),
                IconButton(icon: Icon(Icons.close_rounded, color: colors.onSurfaceVariant), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(controller: _controller, onDetect: _onDetect),
                Container(
                  width: size.width * 0.72, height: size.width * 0.72,
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(16)),
                ),
                Positioned(
                  bottom: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(20)),
                    child: Text('Align barcode / QR within frame', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manualController,
                    decoration: InputDecoration(
                      hintText: 'Or enter barcode manually...',
                      hintStyle: GoogleFonts.inter(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: (_) => _submitManual(),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _submitManual,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
