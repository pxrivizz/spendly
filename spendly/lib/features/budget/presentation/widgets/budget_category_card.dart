import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

/// Category card with mini circular ring progress indicator.
class BudgetCategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final double spent;
  final double total;

  const BudgetCategoryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.spent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (spent / total).clamp(0.0, 1.0);
    final isOverBudget = spent > total;
    final progressColor = isOverBudget ? AppColors.error : iconColor;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Category icon
          Container(
            width: AppSpacing.iconContainerMd,
            height: AppSpacing.iconContainerMd,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.1),
              border: Border.all(color: iconColor.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          // Label + amounts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₺${_formatNumber(spent)} / ₺${_formatNumber(total)}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: isOverBudget
                        ? AppColors.error
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Mini ring
          SizedBox(
            width: 48,
            height: 48,
            child: CustomPaint(
              painter: _MiniRingPainter(
                percentage: percentage,
                color: progressColor,
              ),
              child: Center(
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: AppTextStyles.labelCaps.copyWith(
                    fontSize: 10,
                    color: progressColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _MiniRingPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _MiniRingPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 4.0;

    // Background
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniRingPainter oldDelegate) =>
      oldDelegate.percentage != percentage || oldDelegate.color != color;
}
