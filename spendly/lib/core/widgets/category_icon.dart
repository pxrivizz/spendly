import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A circular icon container with a colored background and optional glow.
///
/// Used throughout the app for category icons in transactions, budgets, etc.
class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final bool filled;
  final bool showGlow;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppSpacing.iconContainerLg,
    this.filled = true,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    );
  }
}
