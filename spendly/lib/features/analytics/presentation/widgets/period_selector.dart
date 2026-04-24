import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Week/Month/Year toggle pills for the analytics screen.
class PeriodSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PeriodSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isActive = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: isActive
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        )
                      : null,
                ),
                child: Text(
                  label,
                  style: AppTextStyles.bodySm.copyWith(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
