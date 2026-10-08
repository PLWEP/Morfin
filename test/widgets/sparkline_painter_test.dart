import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morfin/core/widgets/sparkline_painter.dart';

void main() {
  group('SparklinePainter Tests', () {
    testWidgets('renders CustomPaint with SparklinePainter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 40,
                child: CustomPaint(
                  painter: SparklinePainter(
                    data: const [10.0, 20.0, 15.0, 30.0],
                    lineColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    test('shouldRepaint detects data and color changes', () {
      const painter1 = SparklinePainter(
        data: [1.0, 2.0, 3.0],
        lineColor: Colors.green,
      );

      const painter2 = SparklinePainter(
        data: [1.0, 2.0, 3.0],
        lineColor: Colors.green,
      );

      const painterDifferentColor = SparklinePainter(
        data: [1.0, 2.0, 3.0],
        lineColor: Colors.red,
      );

      const painterDifferentData = SparklinePainter(
        data: [1.0, 5.0],
        lineColor: Colors.green,
      );

      expect(painter1.shouldRepaint(painter2), false);
      expect(painter1.shouldRepaint(painterDifferentColor), true);
      expect(painter1.shouldRepaint(painterDifferentData), true);
    });
  });
}
