import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// A single transaction row in the recent transactions list.
class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isIncome = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: AppSpacing.iconContainerLg,
              height: AppSpacing.iconContainerLg,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              amount,
              style: AppTextStyles.bodyLg.copyWith(
                fontWeight: FontWeight.w600,
                color: isIncome ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
