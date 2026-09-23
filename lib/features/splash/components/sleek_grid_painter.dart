import 'package:flutter/material.dart';

class SleekGridPainter extends CustomPainter {
  final Color color;

  const SleekGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SleekGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
