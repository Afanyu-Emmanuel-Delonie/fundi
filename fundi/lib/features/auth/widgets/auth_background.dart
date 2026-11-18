import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Blue curves: top-left and bottom-right.
/// Traced from the 430 × 932 design and scaled to the screen width.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _CurvesPainter()),
      ),
    );
  }
}

class _CurvesPainter extends CustomPainter {
  static const _designWidth = 430.0;
  static const _designHeight = 932.0;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _designWidth;
    final paint = Paint()..color = AppColors.primary;

    // Top-left curve
    final top = Path()
      ..moveTo(0, 0)
      ..lineTo(325, 0)
      ..cubicTo(300, 35, 255, 48, 215, 42)
      ..cubicTo(175, 36, 150, 48, 120, 75)
      ..cubicTo(95, 98, 70, 95, 45, 110)
      ..cubicTo(25, 122, 12, 138, 0, 142)
      ..close();

    canvas.save();
    canvas.scale(s);
    canvas.drawPath(top, paint);
    canvas.restore();

    // Bottom-right curve, pinned to the bottom of the screen
    final bottom = Path()
      ..moveTo(430, 815)
      ..lineTo(430, 932)
      ..lineTo(190, 932)
      ..cubicTo(215, 905, 235, 885, 265, 880)
      ..cubicTo(300, 875, 320, 895, 350, 880)
      ..cubicTo(380, 865, 400, 830, 430, 815)
      ..close();

    canvas.save();
    canvas.translate(0, size.height - _designHeight * s);
    canvas.scale(s);
    canvas.drawPath(bottom, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}