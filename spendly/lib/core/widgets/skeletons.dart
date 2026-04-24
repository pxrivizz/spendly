import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF161D2A),
      highlightColor: const Color(0xFF1C2640),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF161D2A),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SkeletonBox(width: double.infinity, height: 160, radius: 24),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 200, radius: 24),
          const SizedBox(height: 16),
          ...List.generate(3, (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonBox(
              width: double.infinity, height: 68, radius: 16),
          )),
        ],
      ),
    );
  }
}

class ChartSkeleton extends StatelessWidget {
  const ChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(width: double.infinity, height: 200, radius: 24);
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (_) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: SkeletonBox(
          width: double.infinity, height: 68, radius: 16),
      )),
    );
  }
}
