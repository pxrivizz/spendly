import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Ambient mesh gradient background layer matching Stitch AI designs.
///
/// Creates overlapping radial gradients with subtle primary and secondary
/// tints on a deep dark background.
class MeshGradientBackground extends StatelessWidget {
  /// Optional override for the primary glow color
  final Color? primaryGlow;

  /// Optional override for the secondary glow color
  final Color? secondaryGlow;

  const MeshGradientBackground({
    super.key,
    this.primaryGlow,
    this.secondaryGlow,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top-left primary glow
            Positioned(
              top: -MediaQuery.sizeOf(context).height * 0.1,
              left: -MediaQuery.sizeOf(context).width * 0.1,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: MediaQuery.sizeOf(context).width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (primaryGlow ?? AppColors.primary).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-right secondary glow
            Positioned(
              bottom: -MediaQuery.sizeOf(context).height * 0.2,
              right: -MediaQuery.sizeOf(context).width * 0.1,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (secondaryGlow ?? AppColors.secondary).withValues(alpha: 0.04),
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
}
