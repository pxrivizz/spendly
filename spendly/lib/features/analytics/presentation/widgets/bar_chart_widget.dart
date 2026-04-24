import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Bar chart data point.
class BarChartBar {
  final String label;
  final double current; // 0.0 – 1.0
  final double previous; // 0.0 – 1.0

  const BarChartBar({
    required this.label,
    required this.current,
    required this.previous,
  });
}

/// Grouped bar chart with current vs previous period comparison.
class BarChartWidget extends StatelessWidget {
  final List<BarChartBar> barData;
  final double height;

  const BarChartWidget({
    super.key,
    required this.barData,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barData.map((bar) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bar group
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current bar
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: bar.current,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.7),
                                    AppColors.primary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Previous bar
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: bar.previous,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                color: AppColors.surfaceBright,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Label
                Text(
                  bar.label,
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
