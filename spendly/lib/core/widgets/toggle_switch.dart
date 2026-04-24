import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A custom toggle switch matching the Stitch AI design system.
///
/// Active state: primary tinted background with primary knob + glow.
/// Inactive state: dark surface background with outline knob.
class SpendlyToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SpendlyToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceContainerHighest,
          border: Border.all(
            color: value
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.outlineVariant,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors.primary : AppColors.outline,
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
