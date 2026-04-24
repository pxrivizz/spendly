import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Shared top app bar widget matching the Stitch AI design.
///
/// Features: avatar (left), "Spendly" logo (center), calendar icon (right).
/// Frosted glass background with primary-tinted bottom border.
class SpendlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onCalendarTap;

  const SpendlyAppBar({
    super.key,
    this.avatarUrl,
    this.onAvatarTap,
    this.onCalendarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.navBarBackground,
            border: Border(
              bottom: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: AppSpacing.avatarSm,
                  height: AppSpacing.avatarSm,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildFallbackAvatar(),
                          )
                        : _buildFallbackAvatar(),
                  ),
                ),
              ),

              // Spendly logo
              Text(
                'Spendly',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),

              // Calendar icon
              GestureDetector(
                onTap: onCalendarTap,
                child: Container(
                  width: AppSpacing.avatarSm,
                  height: AppSpacing.avatarSm,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary.withValues(alpha: 0.8),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: AppColors.surfaceContainerHigh,
      child: const Icon(
        Icons.person,
        color: AppColors.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}
