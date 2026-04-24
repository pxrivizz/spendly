import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Horizontal scrollable filter chips.
class SpendlyFilterChips extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SpendlyFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isActive = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : AppColors.outlineVariant,
                  ),
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
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
