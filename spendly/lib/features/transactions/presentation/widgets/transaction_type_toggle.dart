import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Expense/Income segmented toggle control.
class TransactionTypeToggle extends StatelessWidget {
  final bool isExpense;
  final ValueChanged<bool> onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isExpense,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          _buildSegment(
            label: 'Gider',
            isActive: isExpense,
            onTap: () => onChanged(true),
            activeColor: AppColors.error,
          ),
          _buildSegment(
            label: 'Gelir',
            isActive: !isExpense,
            onTap: () => onChanged(false),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: isActive
                ? Border.all(color: activeColor.withValues(alpha: 0.3))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? activeColor : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
