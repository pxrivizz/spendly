

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

enum OnboardingIllustrationType { cards, chart, target }

/// Abstract CSS-art style illustrations for onboarding slides.
///
/// Recreates the layered glass cards, bar chart, and concentric target
/// ring designs from the Stitch AI onboarding mockups.
class OnboardingIllustration extends StatelessWidget {
  final OnboardingIllustrationType type;

  const OnboardingIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: switch (type) {
        OnboardingIllustrationType.cards => _buildCardsIllustration(),
        OnboardingIllustrationType.chart => _buildChartIllustration(),
        OnboardingIllustrationType.target => _buildTargetIllustration(),
      },
    );
  }

  /// Slide 1: Overlapping glass cards with floating lira coin
  Widget _buildCardsIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background card
        Positioned(
          top: 0,
          left: 0,
          child: Transform.rotate(
            angle: -0.21, // ~ -12 degrees
            child: Container(
              width: 160,
              height: 224,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBright,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 80,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBright,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Foreground card
        Positioned(
          bottom: 0,
          right: 16,
          child: Transform.rotate(
            angle: 0.105, // ~6 degrees
            child: Container(
              width: 176,
              height: 240,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wallet label
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Balance',
                        style: AppTextStyles.labelCaps,
                      ),
                    ],
                  ),
                  // Amount
                  Text(
                    '₺ 4,250',
                    style: AppTextStyles.h3,
                  ),
                  // Mini transaction row
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBright,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBright,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Floating Lira Coin
        Positioned(
          top: 70,
          left: 100,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.secondaryContainer],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  blurRadius: 40,
                ),
              ],
            ),
            child: const Icon(
              Icons.currency_lira,
              size: 40,
              color: Color(0xFF462A00),
            ),
          ),
        ),
      ],
    );
  }

  /// Slide 2: Bar chart with glowing active bar
  Widget _buildChartIllustration() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBar(0.4, false),
                _buildBar(0.7, false),
                _buildBar(1.0, true),
                _buildBar(0.6, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFraction, bool isActive) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FractionallySizedBox(
          heightFactor: heightFraction,
          alignment: Alignment.bottomCenter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  gradient: isActive
                      ? const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC46F1C5),
                            AppColors.primary,
                          ],
                        )
                      : null,
                  color: isActive ? null : AppColors.surfaceBright,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 24,
                          ),
                        ]
                      : null,
                ),
              ),
              if (isActive)
                Positioned(
                  top: -12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Slide 3: Concentric target rings with glowing center
  Widget _buildTargetIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer dashed ring
        Container(
          width: 224,
          height: 224,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
        ),
        // Middle ring
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
        ),
        // Inner ring
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.05),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
        ),
        // Center target
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryFixedDim],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.6),
                blurRadius: 32,
              ),
            ],
          ),
          child: const Icon(
            Icons.flag_rounded,
            size: 28,
            color: AppColors.onPrimary,
          ),
        ),
        // Glowing path line below
        Positioned(
          bottom: 0,
          child: Container(
            width: 4,
            height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primary.withValues(alpha: 0.5),
                  AppColors.primary,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
