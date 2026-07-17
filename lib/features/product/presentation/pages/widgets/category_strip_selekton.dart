import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class CategoryStripSkeleton extends StatelessWidget {
  const CategoryStripSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Column(
        children: [
          ShimmerLoader(
            height: 68,
            width: 68,
            borderRadius: BorderRadius.circular(34),
          ),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 10, width: 56),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
