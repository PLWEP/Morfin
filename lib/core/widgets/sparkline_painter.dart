import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final double strokeWidth;

  const SparklinePainter({
    required this.data,
    required this.lineColor,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final minVal = data.reduce((curr, next) => curr < next ? curr : next);
    final maxVal = data.reduce((curr, next) => curr > next ? curr : next);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    final stepX = size.width / (data.length - 1);
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY = (data[i] - minVal) / range;
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}
