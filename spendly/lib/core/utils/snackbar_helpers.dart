import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Displays a themed error SnackBar at the bottom of the screen.
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.onError, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: const Duration(seconds: 4),
      ),
    );
}

/// Displays a themed success SnackBar at the bottom of the screen.
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.onPrimary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: const Duration(seconds: 3),
      ),
    );
}
