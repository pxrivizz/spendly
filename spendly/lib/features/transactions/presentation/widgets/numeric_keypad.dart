import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Custom 3×4 numeric keypad matching the Stitch design.
class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;

  const NumericKeypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      [',', '0', '⌫'],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: keys.map((row) {
          return Row(
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: _buildKey(key),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    final isBackspace = key == '⌫';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onKeyPressed(key),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    color: AppColors.onSurfaceVariant,
                    size: 22,
                  )
                : Text(
                    key,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
