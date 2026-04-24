import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

/// Hero balance card showing total spend, budget progress, and trend.
class BalanceCard extends StatelessWidget {
  final String spentAmount;
  final String spentDecimal;
  final String budgetTotal;
  final int budgetPercentage;
  final String trendPercentage;
  final bool trendIsUp;

  const BalanceCard({
    super.key,
    required this.spentAmount,
    required this.spentDecimal,
    required this.budgetTotal,
    required this.budgetPercentage,
    required this.trendPercentage,
    required this.trendIsUp,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Stack(
        children: [
          // Glow effect
          Positioned(
            top: -96,
            right: -96,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bu Ay Harcandı',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  // Trend badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendIsUp
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 16,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          trendPercentage,
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.unit),

              // Amount
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(spentAmount, style: AppTextStyles.h1),
                  Text(
                    spentDecimal,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Budget progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bütçe: $budgetTotal',
                    style: AppTextStyles.labelCaps,
                  ),
                  Text(
                    '%$budgetPercentage',
                    style: AppTextStyles.labelCaps,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.unit),
              // Progress bar
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: budgetPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
