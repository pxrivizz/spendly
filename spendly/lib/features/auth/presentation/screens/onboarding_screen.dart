import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/onboarding_illustration.dart';

/// Onboarding screen with 3-slide horizontal PageView.
///
/// Features abstract CSS-art illustrations, text content,
/// pagination dots, and a full-width CTA button.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _SlideData(
      title: 'Know where every lira goes',
      subtitle:
          'Track your daily expenses effortlessly and gain total control over your financial destiny.',
      illustrationType: OnboardingIllustrationType.cards,
    ),
    _SlideData(
      title: 'Visualize your spending patterns',
      subtitle:
          'Beautiful, insightful charts that transform raw data into clear financial intelligence.',
      illustrationType: OnboardingIllustrationType.chart,
    ),
    _SlideData(
      title: 'Set goals. Stay on track.',
      subtitle:
          'Define your financial milestones and let intelligent insights guide you to success.',
      illustrationType: OnboardingIllustrationType.target,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mesh gradient backgrounds
          _buildMeshGradients(context),

          // Page content
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.paddingOf(context).top + AppSpacing.xl,
                    ),
                    // Illustration
                    Expanded(
                      child: Center(
                        child: OnboardingIllustration(
                          type: slide.illustrationType,
                        ),
                      ),
                    ),
                    // Text content
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      slide.title,
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      slide.subtitle,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Bottom space for CTA
                    const SizedBox(height: 200),
                  ],
                ),
              );
            },
          ),

          // Fixed bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMeshGradients(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.7,
                height: MediaQuery.sizeOf(context).height * 0.4,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.0,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: MediaQuery.sizeOf(context).height * 0.3,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: 1.0,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
        top: 64,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background.withValues(alpha: 0.95),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pagination dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 32 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  boxShadow: _currentPage == index
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // CTA Button
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: _currentPage == _slides.length - 1
                  ? () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarding_completed', true);
                      if (!context.mounted) return;
                      context.go('/login');
                    }
                  : () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppColors.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String title;
  final String subtitle;
  final OnboardingIllustrationType illustrationType;

  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.illustrationType,
  });
}
