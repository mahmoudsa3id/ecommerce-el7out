import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/helper/helpers.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/widgets/shimmer_loader.dart';
import 'package:ecommerce_el7out/features/category/presentation/pages/category_detai_page.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatefulWidget {
  final ProductEntity product;

  /// بادئة بتتضاف لتاج الـ Hero عشان تمنع تكرار نفس التاج لما نفس
  /// المنتج يظهر في أكتر من سكشن في نفس الوقت (شريط الأكتر مبيعًا +
  /// جريد المنتجات الجديدة)، وده كان سبب:
  /// "There are multiple heroes that share the same tag within a subtree"
  final String heroTagPrefix;

  const ProductCard({
    super.key,
    required this.product,
    this.heroTagPrefix = 'default',
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0,
    upperBound: 0.03,
  );
  bool _isFavorite = false;

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final compareAt = p.compareAtPrice;
    final showSale = p.isOnSale && compareAt != null;
    final rating = pseudoRatingFor(p.id);

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      onTap: () => context.push(RoutePaths.productDetailsPath(p.id)),
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (_, child) =>
            Transform.scale(scale: 1 - _pressCtrl.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-image-${widget.heroTagPrefix}-${p.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      if (p.imageUrls.isNotEmpty)
                        Image.network(
                          p.imageUrls.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return const ShimmerLoader(
                              height: double.infinity,
                              width: double.infinity,
                            );
                          },
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.image_not_supported_outlined),
                          ),
                        )
                      else
                        const Center(
                          child: Icon(Icons.checkroom_outlined, size: 40),
                        ),
                      if (p.isNew)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: _TagBadge('جديد', Colors.black, Colors.white),
                        ),
                      if (showSale)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: _TagBadge(
                            '-${p.discountPercent.toStringAsFixed(0)}%',
                            AppColors.error,
                            Colors.white,
                          ),
                        ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: WishlistGlassButton(product: p),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              p.brand,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.55),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              p.name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            RatingStars(rating: rating, size: 12),
            const SizedBox(height: 5),
            Row(
              children: [
                PriceText(
                  p.price,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                if (showSale) ...[
                  const SizedBox(width: 6),
                  PriceText(
                    compareAt,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: TextDecoration.lineThrough,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating; // 0..5
  final double size;
  final Color? color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? AppColors.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final diff = rating - i;
        IconData icon;
        if (diff >= 1) {
          icon = Icons.star_rounded;
        } else if (diff >= 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: size, color: starColor);
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Price text — Builder مستقل عشان نضمن إن context.select (جوه
// context.money) بيتنفذ على Element عادي، مش على الـ Sliver child
// element مباشرة، لأن ده بالظبط سبب كراش:
// "Tried to use context.select inside a SliverList/SliderGridView"
// اللي كان بيحصل في أي كارت بيتعرض جوه ListView.builder / GridView.builder
// / ListView.separated (شريط الأكتر مبيعًا، الجريد بتاع المنتجات الجديدة،
// وقائمة استبدال المنتج في المقارنة).
// ══════════════════════════════════════════════════════════════
class PriceText extends StatelessWidget {
  final num amount;
  final TextStyle? style;
  final TextDecoration? decoration;

  const PriceText(this.amount, {super.key, this.style, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) => Text(
        innerContext.money(amount),
        style: decoration != null
            ? (style ?? const TextStyle()).copyWith(decoration: decoration)
            : style,
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _TagBadge(this.text, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
