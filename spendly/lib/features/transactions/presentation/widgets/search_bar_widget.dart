import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Search input with filter button.
class SpendlySearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SpendlySearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.onSurfaceVariant,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.outline,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerHigh,
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.onSurfaceVariant,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
