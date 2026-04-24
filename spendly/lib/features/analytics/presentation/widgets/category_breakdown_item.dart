import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Category row with icon, label, amount, and progress bar.
class CategoryBreakdownItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;
  final int percentage;

  const CategoryBreakdownItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Icon
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
          // Label + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      amount,
                      style: AppTextStyles.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Progress bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            iconColor.withValues(alpha: 0.5),
                            iconColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Percentage label
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '%$percentage',
                    style: AppTextStyles.labelCaps.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
