import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Pill-shaped month navigator with left/right chevrons.
class MonthSelector extends StatelessWidget {
  final String month;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const MonthSelector({
    super.key,
    required this.month,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.unit),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChevronButton(Icons.chevron_left, onPrevious),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              month,
              style: AppTextStyles.labelCaps.copyWith(
                color: AppColors.onSurface,
                letterSpacing: 2.0,
              ),
            ),
          ),
          _buildChevronButton(Icons.chevron_right, onNext),
        ],
      ),
    );
  }

  Widget _buildChevronButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
      ),
    );
  }
}
