import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Circular ring chart showing budget remaining/spent/total.
class BudgetRingChart extends StatelessWidget {
  final double remaining;
  final double spent;
  final double total;

  const BudgetRingChart({
    super.key,
    required this.remaining,
    required this.spent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = spent / total;

    return SizedBox(
      width: 224,
      height: 224,
      child: CustomPaint(
        painter: _RingPainter(percentage: percentage),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kalan',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '₺${remaining.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percentage;

  _RingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final strokeWidth = 18.0;
    final radius = outerRadius - strokeWidth / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.7),
          AppColors.primary,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      progressPaint,
    );

    // Glow effect at the tip
    final tipAngle = -math.pi / 2 + 2 * math.pi * percentage;
    final tipX = center.dx + radius * math.cos(tipAngle);
    final tipY = center.dy + radius * math.sin(tipAngle);

    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(Offset(tipX, tipY), 10, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
