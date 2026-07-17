// ============================================================
// core/widgets/shimmer_loader.dart  (EXTENDED version)
// ============================================================
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShimmerLoader extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const ShimmerLoader({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.shimmerDark : AppColors.shimmerLight;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: colors,
            stops: const [0.1, 0.5, 0.9],
            begin: Alignment(-1.0 - _ctrl.value * 2, 0),
            end: Alignment(1.0 - _ctrl.value * 2, 0),
          ).createShader(bounds),
          child: Container(
            height: widget.height,
            width: widget.width,
            color: colors.first,
          ),
        ),
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;
  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (_, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShimmerLoader(
              height: double.infinity,
              width: double.infinity,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          const ShimmerLoader(height: 11, width: 80),
          const SizedBox(height: 5),
          const ShimmerLoader(height: 13, width: 130),
          const SizedBox(height: 5),
          const ShimmerLoader(height: 13, width: 60),
        ],
      ),
    );
  }
}
