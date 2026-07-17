// features/category/presentation/pages/category_detail_page.dart
//
// UI-only redesign. ProductCubit / ProductState / ProductEntity and the
// `loadProducts(category: slug)` call are untouched. Filtering & sorting
// below operate purely on the already-loaded `products` list — no new
// repository or cubit methods are introduced.
//
// FIX (this revision):
//  1) ROOT CAUSE (real one) of "SliverGeometry is not valid: layoutExtent
//     exceeds paintExtent": the pinned SliverPersistentHeader's delegate
//     (`_StickyFilterBar`) returned a child (ClipRect > GlassContainer > Row)
//     whose *actual* rendered height (54.6) was smaller than the declared
//     `minExtent`/`maxExtent` (60.0), because RenderSliverPersistentHeader
//     lays its child out with a LOOSE height constraint (0..maxExtent), not
//     a tight one. When the Row's intrinsic content height came out smaller
//     than 60, the sliver still reserved layoutExtent = 60 (since it's
//     pinned) while paintExtent reflected the smaller actual child size ->
//     assertion failure. Fixed by wrapping the delegate's build() output in
//     `SizedBox(height: maxExtent, ...)` so the child ALWAYS paints exactly
//     the declared extent, regardless of its intrinsic content size.
//     (ClampingScrollPhysics from a previous revision was a red herring —
//     it only affects bounce/overscroll and did not address this mismatch,
//     which is why the crash persisted after that change.)
//  2) Removed all `product.compareAtPrice!` null-check operators. They ran
//     under an `isOnSale` guard, but if that flag and the field ever get
//     out of sync (e.g. mid-update, stale cache), it throws
//     "Null check operator used on a null value". Now using a local
//     nullable variable + null-safe checks everywhere instead of `!`.
import 'package:ecommerce_el7out/core/theme/luxory_pallete.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_el7out/features/product/presentation/cubits/product_cubit.dart';
import 'package:ecommerce_el7out/features/product/presentation/cubits/product_state.dart';
import 'package:ecommerce_el7out/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_el7out/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/shimmer_loader.dart';

enum _SortMode { featured, priceLowHigh, priceHighLow, nameAZ }

class CategoryDetailPage extends StatelessWidget {
  final String slug;
  const CategoryDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductCubit>()..loadProducts(category: slug),
      child: _CategoryDetailView(slug: slug),
    );
  }
}

class _CategoryDetailView extends StatefulWidget {
  final String slug;
  const _CategoryDetailView({required this.slug});

  @override
  State<_CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<_CategoryDetailView> {
  bool _isGrid = true;
  _SortMode _sort = _SortMode.featured;
  String? _colorFilter;

  String get _title => widget.slug.toUpperCase().replaceAll('-', ' ');

  List<ProductEntity> _applyFilterSort(List<ProductEntity> source) {
    var list = List<ProductEntity>.from(source);
    if (_colorFilter != null) {
      list = list
          .where((p) => p.variants.any((v) => v.colorName == _colorFilter))
          .toList();
    }
    switch (_sort) {
      case _SortMode.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortMode.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortMode.nameAZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortMode.featured:
        break;
    }
    return list;
  }

  Set<String> _availableColors(List<ProductEntity> products) {
    final colors = <String>{};
    for (final p in products) {
      for (final v in p.variants) {
        colors.add(v.colorName);
      }
    }
    return colors;
  }

  Future<void> _openFilterSheet(List<ProductEntity> products) async {
    final colors = _availableColors(products);
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => _FilterSheet(
        colors: colors,
        selected: _colorFilter,
        onApply: (color) => setState(() => _colorFilter = color),
      ),
    );
  }

  Future<void> _openSortSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _SortSheet(
        current: _sort,
        onSelected: (mode) => setState(() => _sort = mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
        ),
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  const _CategoryHeader(
                    subtitle: 'جارٍ تحميل المنتجات...',
                    count: null,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                    sliver: _LuxuryGridSkeleton(),
                  ),
                ],
              ),
              error: (msg) => Center(child: Text(msg)),
              loaded: (products) {
                final displayed = _applyFilterSort(products);
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    _CategoryHeader(
                      subtitle:
                          'مجموعة مختارة بعناية من $_title بأحدث التصاميم.',
                      count: products.length,
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyFilterBar(
                        isGrid: _isGrid,
                        activeFilterCount: _colorFilter == null ? 0 : 1,
                        sortLabel: _sortLabel(_sort),
                        onFilterTap: () => _openFilterSheet(products),
                        onSortTap: _openSortSheet,
                        onViewToggle: () => setState(() => _isGrid = !_isGrid),
                      ),
                    ),
                    if (displayed.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.pageHorizontal,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 48),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'لا توجد منتجات متاحة حاليًا',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              if (_colorFilter != null) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _colorFilter = null),
                                  child: const Text('مسح الفلاتر'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.md,
                          AppSpacing.pageHorizontal,
                          AppSpacing.pageHorizontal * 2,
                        ),
                        sliver: _isGrid
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          ResponsiveLayout.gridColumns(context),
                                      mainAxisSpacing: AppSpacing.md,
                                      crossAxisSpacing: AppSpacing.md,
                                      childAspectRatio: 0.62,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => StaggeredEntrance(
                                    index: i,
                                    child: _LuxuryProductCard(
                                      product: displayed[i],
                                    ),
                                  ),
                                  childCount: displayed.length,
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: StaggeredEntrance(
                                      index: i,
                                      child: _LuxuryProductListTile(
                                        product: displayed[i],
                                      ),
                                    ),
                                  ),
                                  childCount: displayed.length,
                                ),
                              ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _sortLabel(_SortMode mode) {
    switch (mode) {
      case _SortMode.featured:
        return 'الأكثر تميزًا';
      case _SortMode.priceLowHigh:
        return 'السعر: من الأقل للأعلى';
      case _SortMode.priceHighLow:
        return 'السعر: من الأعلى للأقل';
      case _SortMode.nameAZ:
        return 'الاسم: أ - ي';
    }
  }
}

class _CategoryHeader extends StatelessWidget {
  final String subtitle;
  final int? count;
  const _CategoryHeader({required this.subtitle, required this.count});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          8,
          AppSpacing.pageHorizontal,
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مجموعة الحوت', style: LuxuryPalette.eyebrow(context)),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            if (count != null) ...[
              const SizedBox(height: 6),
              Text(
                '$count ${count == 1 ? 'منتج' : 'منتجًا'}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: LuxuryPalette.champagne,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StickyFilterBar extends SliverPersistentHeaderDelegate {
  final bool isGrid;
  final int activeFilterCount;
  final String sortLabel;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final VoidCallback onViewToggle;

  _StickyFilterBar({
    required this.isGrid,
    required this.activeFilterCount,
    required this.sortLabel,
    required this.onFilterTap,
    required this.onSortTap,
    required this.onViewToggle,
  });

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // FIX (root cause): RenderSliverPersistentHeader lays its child out with
    // a LOOSE height constraint (0..maxExtent), not a tight one. If the
    // Row's intrinsic content height ends up smaller than the declared
    // maxExtent (60), the sliver still reserves layoutExtent = 60 (pinned)
    // while paintExtent reflects the smaller actual child size, causing
    // "SliverGeometry is not valid: layoutExtent exceeds paintExtent".
    // Wrapping in SizedBox(height: maxExtent) forces the child to always
    // paint exactly the declared extent, eliminating the mismatch.
    return SizedBox(
      height: maxExtent,
      child: ClipRect(
        child: GlassContainer(
          borderRadius: 0,
          blurSigma: 16,
          tint: Theme.of(context).scaffoldBackgroundColor,
          tintOpacity: 0.72,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.6,
            ),
          ),
          shadows: const [],
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: _BarChip(
                  icon: Icons.tune_rounded,
                  label: activeFilterCount > 0
                      ? ' ($activeFilterCount)تصفية'
                      : 'تصفية',
                  onTap: onFilterTap,
                  highlighted: activeFilterCount > 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BarChip(
                  icon: Icons.swap_vert_rounded,
                  label: sortLabel,
                  onTap: onSortTap,
                ),
              ),
              const SizedBox(width: 10),
              _BarChip(
                icon: isGrid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                label: '',
                onTap: onViewToggle,
                square: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyFilterBar oldDelegate) {
    return oldDelegate.isGrid != isGrid ||
        oldDelegate.activeFilterCount != activeFilterCount ||
        oldDelegate.sortLabel != sortLabel;
  }
}

class _BarChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;
  final bool square;

  const _BarChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted
          ? LuxuryPalette.champagne.withOpacity(0.16)
          : Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: square ? 12 : 12,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: highlighted ? LuxuryPalette.champagneDeep : null,
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: highlighted ? LuxuryPalette.champagneDeep : null,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final Set<String> colors;
  final String? selected;
  final ValueChanged<String?> onApply;

  const _FilterSheet({
    required this.colors,
    required this.selected,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _local;

  @override
  void initState() {
    super.initState();
    _local = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GlassContainer(
        borderRadius: 24,
        tint: Theme.of(context).scaffoldBackgroundColor,
        tintOpacity: 0.92,
        blurSigma: 24,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Filter by color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.colors
                  .map(
                    (c) => ChoiceChip(
                      label: Text(c),
                      selected: _local == c,
                      onSelected: (sel) =>
                          setState(() => _local = sel ? c : null),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onApply(null);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: LuxuryPalette.champagne,
                    ),
                    onPressed: () {
                      widget.onApply(_local);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final _SortMode current;
  final ValueChanged<_SortMode> onSelected;

  const _SortSheet({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    Widget tile(_SortMode mode, String label) {
      final selected = mode == current;
      return ListTile(
        title: Text(label),
        trailing: selected
            ? const Icon(Icons.check_rounded, color: LuxuryPalette.champagne)
            : null,
        onTap: () {
          onSelected(mode);
          Navigator.of(context).pop();
        },
      );
    }

    return GlassContainer(
      borderRadius: 24,
      tint: Theme.of(context).scaffoldBackgroundColor,
      tintOpacity: 0.92,
      blurSigma: 24,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          tile(_SortMode.featured, 'Featured'),
          tile(_SortMode.priceLowHigh, 'Price: Low to High'),
          tile(_SortMode.priceHighLow, 'Price: High to Low'),
          tile(_SortMode.nameAZ, 'Name: A–Z'),
        ],
      ),
    );
  }
}

class _LuxuryGridSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.gridColumns(context),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => ShimmerLoader(
          height: double.infinity,
          borderRadius: BorderRadius.circular(16),
        ),
        childCount: 6,
      ),
    );
  }
}

class _LuxuryProductCard extends StatelessWidget {
  final ProductEntity product;
  const _LuxuryProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
    // Local nullable instead of `product.compareAtPrice!` — avoids
    // "Null check operator used on a null value" if isOnSale and
    // compareAtPrice ever get out of sync.
    final compareAt = product.compareAtPrice;
    final showSale = product.isOnSale && compareAt != null && compareAt > 0;

    return PressableScale(
      onTap: () => context.push(RoutePaths.productDetailsPath(product.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-image-${product.id}-0',
                    child: image != null
                        ? Image.network(image, fit: BoxFit.cover)
                        : Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const Icon(
                              Icons.checkroom_outlined,
                              size: 36,
                            ),
                          ),
                  ),
                  if (showSale)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _Badge(
                        label:
                            '-${(((compareAt - product.price) / compareAt) * 100).round()}%',
                        color: Colors.redAccent,
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: WishlistGlassButton(product: product),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.brand.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: LuxuryPalette.champagne,
                letterSpacing: 1,
              ),
            ),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                SizedBox(width: 5),
                Text(
                  context.money(product.price),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (showSale) ...[
                  const SizedBox(width: 8),
                  Text(
                    context.money(compareAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Theme.of(context).hintColor,
                    ),
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

class _LuxuryProductListTile extends StatelessWidget {
  final ProductEntity product;
  const _LuxuryProductListTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
    // Same null-safe local pattern as the grid card above.
    final compareAt = product.compareAtPrice;
    final showSale = product.isOnSale && compareAt != null && compareAt > 0;

    return PressableScale(
      onTap: () => context.push(RoutePaths.productDetailsPath(product.id)),
      child: GlassContainer(
        borderRadius: 16,
        tint: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        tintOpacity: 0.04,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 92,
                height: 110,
                child: Hero(
                  tag: 'product-image-${product.id}-0',
                  child: image != null
                      ? Image.network(image, fit: BoxFit.cover)
                      : Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: LuxuryPalette.champagne,
                    ),
                  ),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        context.money(product.price),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (showSale) ...[
                        const SizedBox(width: 8),
                        Text(
                          context.money(compareAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            WishlistGlassButton(product: product),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A small glass "favorite" button reused on cards. NOTE: this is a purely
/// presentational placeholder here (no WishlistCubit call) because the grid
/// item is `ProductEntity`, not `WishlistItemEntity` — wiring it up is a
/// one-line change identical to the pattern already used on the Product
/// Details page (`_WishlistButton`), left as-is to avoid duplicating
/// business logic across two files.
class WishlistGlassButton extends StatefulWidget {
  final ProductEntity product;
  const WishlistGlassButton({super.key, required this.product});

  @override
  State<WishlistGlassButton> createState() => WishlistGlassButtonState();
}

class WishlistGlassButtonState extends State<WishlistGlassButton> {
  bool _inWishlist = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final result = await getIt<WishlistCubit>().isInWishlist(widget.product.id);
    if (!mounted) return;
    setState(() {
      _inWishlist = result;
      _loading = false;
    });
  }

  Future<void> _toggle() async {
    // Optimistic UI update so it feels instant.
    setState(() => _inWishlist = !_inWishlist);
    await getIt<WishlistCubit>().toggle(
      WishlistItemEntity(
        productId: widget.product.id,
        name: widget.product.name,
        brand: widget.product.brand,
        price: widget.product.price,
        imageUrl: widget.product.imageUrls.firstOrNull,
        addedAt: DateTime.now(),
      ),
    );
    // Re-sync with actual repository state in case of failure.
    if (!mounted) return;
    _checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _toggle,
      child: GlassContainer(
        borderRadius: 999,
        tint: Colors.black,
        tintOpacity: 0.28,
        blurSigma: 10,
        shadows: const [],
        padding: const EdgeInsets.all(6),
        child: Icon(
          _inWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: _inWishlist ? Colors.redAccent : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
