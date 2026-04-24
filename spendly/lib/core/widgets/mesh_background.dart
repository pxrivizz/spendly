
import 'package:flutter/material.dart';

class MeshBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0E1A),
    );

    // Top-left teal orb
    final orbPaint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00D4AA).withValues(alpha: 0.15),
          const Color(0xFF00D4AA).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.1, size.height * 0.05),
        radius: size.width * 0.6,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.05),
      size.width * 0.6,
      orbPaint1,
    );

    // Bottom-right amber orb
    final orbPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFB347).withValues(alpha: 0.08),
          const Color(0xFFFFB347).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.9, size.height * 0.85),
        radius: size.width * 0.5,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.85),
      size.width * 0.5,
      orbPaint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
