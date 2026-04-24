import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_card.dart';

/// A glass card container for grouping settings items.
class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isLast = index == children.length - 1;

          return Column(
            children: [
              child,
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 1,
                    color: const Color(0x0DFFFFFF), // white @ 5%
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
