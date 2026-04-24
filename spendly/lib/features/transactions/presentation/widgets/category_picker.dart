import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Category picker item data.
class CategoryPickerItem {
  final IconData icon;
  final String label;
  final Color color;

  const CategoryPickerItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

/// Horizontal scrollable category selector with glowing active state.
class CategoryPicker extends StatelessWidget {
  final List<CategoryPickerItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CategoryPicker({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final cat = entry.value;
          final isActive = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? cat.color.withValues(alpha: 0.15)
                          : AppColors.surfaceContainer,
                      border: Border.all(
                        color: isActive
                            ? cat.color.withValues(alpha: 0.4)
                            : AppColors.outlineVariant,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: cat.color.withValues(alpha: 0.3),
                                blurRadius: 16,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      cat.icon,
                      color: isActive ? cat.color : AppColors.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    cat.label,
                    style: AppTextStyles.labelCaps.copyWith(
                      fontSize: 10,
                      color: isActive ? cat.color : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
