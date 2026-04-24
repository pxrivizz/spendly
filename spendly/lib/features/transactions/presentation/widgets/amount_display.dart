import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Large centered amount display with currency symbol.
class AmountDisplay extends StatelessWidget {
  final String amount;

  const AmountDisplay({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        amount,
        style: AppTextStyles.h1.copyWith(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}
