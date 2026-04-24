import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

/// Transaction data model for the date group.
class TransactionData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;

  const TransactionData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isIncome = false,
  });
}

/// Grouped transaction list with sticky date header in a glass container.
class TransactionDateGroup extends StatelessWidget {
  final String dateLabel;
  final List<TransactionData> transactions;

  const TransactionDateGroup({
    super.key,
    required this.dateLabel,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date label
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            dateLabel,
            style: AppTextStyles.labelCaps.copyWith(
              letterSpacing: 2.0,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        // Glass container with transactions
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final tx = entry.value;
              final isLast = index == transactions.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: AppSpacing.iconContainerLg,
                          height: AppSpacing.iconContainerLg,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tx.iconColor.withValues(alpha: 0.1),
                            border: Border.all(
                              color: tx.iconColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(tx.icon, color: tx.iconColor, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        // Title + subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: AppTextStyles.bodyMd.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                tx.subtitle,
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Amount
                        Text(
                          tx.amount,
                          style: AppTextStyles.bodyLg.copyWith(
                            fontWeight: FontWeight.w600,
                            color: tx.isIncome
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
