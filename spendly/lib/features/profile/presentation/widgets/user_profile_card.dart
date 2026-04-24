import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

/// User profile card with avatar, name, and member since.
class UserProfileCard extends StatelessWidget {
  final String name;
  final String memberSince;
  final String? avatarUrl;

  const UserProfileCard({
    super.key,
    required this.name,
    required this.memberSince,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          // Avatar
          Container(
            width: AppSpacing.avatarLg,
            height: AppSpacing.avatarLg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                color: AppColors.surfaceContainerHigh,
                child: Icon(
                  Icons.person,
                  color: AppColors.onSurfaceVariant,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Name
          Text(
            name,
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Member since
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Üye: $memberSince',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
