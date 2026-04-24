import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF161D2A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0x3300D4AA),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF00D4AA).withValues(alpha: 0.05),
                blurRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}
