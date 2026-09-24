import 'package:flutter/material.dart';

class AppLogoBadge extends StatelessWidget {
  final double size;

  const AppLogoBadge({
    super.key,
    this.size = 96.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _AppLogoPainter(),
      ),
    );
  }
}

class _AppLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120.0;
    final radius = 28.0 * scale;

    // Background squircle #0d1117
    final bgPaint = Paint()
      ..color = const Color(0xFF0D1117)
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    final borderRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        1.0 * scale,
        1.0 * scale,
        size.width - 2.0 * scale,
        size.height - 2.0 * scale,
      ),
      Radius.circular(26.0 * scale),
    );
    canvas.drawRRect(borderRRect, borderPaint);

    // Gradient definition
    final gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF38BDF8),
        Color(0xFF6366F1),
        Color(0xFFEC4899),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final gradPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    // Top trapezoid: M32 36 L88 36 L76 56 L44 56 Z
    final topPath = Path()
      ..moveTo(32.0 * scale, 36.0 * scale)
      ..lineTo(88.0 * scale, 36.0 * scale)
      ..lineTo(76.0 * scale, 56.0 * scale)
      ..lineTo(44.0 * scale, 56.0 * scale)
      ..close();
    canvas.drawPath(topPath, gradPaint);

    // Bottom trapezoid (opacity 0.85): M40 62 L80 62 L68 82 L28 82 Z
    final botPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.85);
    final botPath = Path()
      ..moveTo(40.0 * scale, 62.0 * scale)
      ..lineTo(80.0 * scale, 62.0 * scale)
      ..lineTo(68.0 * scale, 82.0 * scale)
      ..lineTo(28.0 * scale, 82.0 * scale)
      ..close();
    canvas.drawPath(botPath, botPaint);

    // Circle dot: cx="82" cy="74" r="7" fill="#38bdf8"
    final dotPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(82.0 * scale, 74.0 * scale),
      7.0 * scale,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
