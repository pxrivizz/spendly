import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

/// Donut chart data segment.
class DonutSegment {
  final String label;
  final int percentage;
  final Color color;

  const DonutSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

/// Donut chart card using CustomPainter for the conic gradient ring.
class DonutChartCard extends StatelessWidget {
  final List<DonutSegment> segments;
  final String centerLabel;
  final String centerValue;

  const DonutChartCard({
    super.key,
    required this.segments,
    required this.centerLabel,
    required this.centerValue,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Harcama Dağılımı', style: AppTextStyles.h3),
              Icon(
                Icons.more_horiz,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Donut chart
          SizedBox(
            width: 192,
            height: 192,
            child: CustomPaint(
              painter: _DonutPainter(segments: segments),
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        centerLabel,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        centerValue,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Legend
          ...segments.map(
            (segment) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: segment.color,
                          boxShadow: [
                            BoxShadow(
                              color: segment.color.withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        segment.label,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '%${segment.percentage}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the conic-gradient donut ring.
class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;

  _DonutPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.667;
    final strokeWidth = outerRadius - innerRadius;

    double startAngle = -math.pi / 2; // Start from top

    for (final segment in segments) {
      final sweepAngle = (segment.percentage / 100) * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: outerRadius - strokeWidth / 2,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments;
}
