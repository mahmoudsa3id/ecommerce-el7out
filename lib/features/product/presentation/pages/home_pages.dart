import 'dart:async';
import 'dart:math' as math;
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/helper/helpers.dart';
import 'package:ecommerce_el7out/core/widgets/animated_background_orbs.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_el7out/features/product/presentation/cubits/product_cubit.dart';
import 'package:ecommerce_el7out/features/product/presentation/cubits/product_state.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/about_us_section.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/category_horizantal_strip.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/category_strip_selekton.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/contact_us_section.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/glow_button.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/luxory_divider.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/map_illustration.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/paginated_product_grid.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/product_card.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/testimonail_crousol.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/vip_ribbon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../category/presentation/cubit/category_cubit.dart';
import '../../../category/presentation/cubit/category_state.dart';
import '../../domain/entities/product_entity.dart';

export '../../domain/entities/product_entity.dart';

// ══════════════════════════════════════════════════════════════
// App-wide constants
// ══════════════════════════════════════════════════════════════
const String _kLogoPath = 'assets/images/logo.png';

// الصور التلاتة بتاعة البانر الرئيسي بعد الـ AppBar مباشرة.
const List<String> _kHeroBannerImages = [
  'assets/images/container1.png',
  'assets/images/container2.png',
  'assets/images/container3.png',
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductCubit>()..loadProducts()),
        BlocProvider(create: (_) => getIt<CategoryCubit>()..load()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final pagePadding = ResponsiveLayout.horizontalPadding(context);

    Widget sectionPadding(Widget child) => Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb
            ? ResponsiveLayout.horizontalPadding(context)
            : pagePadding,
      ),
      child: child,
    );

    Widget sectionHeader(
      String title, {
      VoidCallback? onViewAll,
      String? subtitle,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(letterSpacing: 1.2),
                  ),
                ],
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(context.l10n.viewAll.toUpperCase()),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackgroundOrbs()),
          CustomScrollView(
            slivers: [
              if (!isWeb)
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  elevation: 2,
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(_kLogoPath, height: 45, fit: BoxFit.contain),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => context.push(RoutePaths.search),
                    ),
                    IconBagBlocBuilder(),
                    const SizedBox(width: 8),
                  ],
                ),
              if (isWeb)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveLayout.horizontalPadding(context),
                    vertical: 24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: FadeSlideIn(
                      child: Center(
                        child: Image.asset(
                          _kLogoPath,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

              // ── VIP Ribbon الفخم ──────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
              SliverToBoxAdapter(child: sectionPadding(const VipRibbon())),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

              // ── أول حاجة بعد الـ AppBar: بانر مدمج (صورة + عرض) ──
              const SliverToBoxAdapter(child: _HeroOfferCarousel()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // ── سيرش بار عصري ────────────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 60),
                    child: const _SearchBarButton(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // ── Trust badges ─────────────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    child: const _TrustBadgesRow(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // ── Flash sale countdown ─────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(const _FlashSaleBanner()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              SliverToBoxAdapter(child: sectionPadding(const LuxuryDivider())),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // ── Categories ───────────────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: sectionHeader(
                      context.l10n.categories,
                      onViewAll: () => context.go(RoutePaths.categories),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: CategoryHorizontalStripBlocBuilder(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // ── Best sellers (شريط أفقي) ──────────────────────
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  final products = state.maybeWhen(
                    loaded: (p) => p,
                    orElse: () => const <ProductEntity>[],
                  );
                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        sectionPadding(
                          FadeSlideIn(
                            child: sectionHeader(
                              context.l10n.explore,
                              subtitle: 'أكتر المنتجات اللي بيحبها عملاؤنا',
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        sectionPadding(_BestSellersStrip(products: products)),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  );
                },
              ),

              // ── مقارنة المنتجات (Product Comparison) ──────────
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  final products = state.maybeWhen(
                    loaded: (p) => p,
                    orElse: () => const <ProductEntity>[],
                  );
                  if (products.length < 2) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        sectionPadding(
                          FadeSlideIn(
                            child: sectionHeader(
                              'قارن واختار',
                              subtitle:
                                  'شوف الفرق قبل ما تقرر، بالسعر والتقييم',
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        sectionPadding(
                          _ProductComparisonSection(products: products),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  );
                },
              ),

              // ── New Arrivals (Paginated Grid) ─────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb
                      ? ResponsiveLayout.horizontalPadding(context)
                      : pagePadding,
                ),
                sliver: SliverToBoxAdapter(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 180),
                    child: sectionHeader(
                      context.l10n.newArrivals,
                      onViewAll: () => context.go(RoutePaths.categories),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
              PaginatedProductGridBlocBuilder(
                isWeb: isWeb,
                pagePadding: pagePadding,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),

              // ── آراء العملاء (Testimonials) ───────────────────
              SliverToBoxAdapter(
                child: sectionPadding(
                  FadeSlideIn(
                    child: sectionHeader(
                      'آراء عملائنا',
                      subtitle: 'أكتر من ١٠٠0٠ عميل بيثقوا فينا كل شهر',
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              const SliverToBoxAdapter(child: TestimonialsCarousel()),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),

              // ── من نحن ───────────────────────────────────────
              SliverToBoxAdapter(child: sectionPadding(const AboutUsSection())),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),

              // ── فروعنا ───────────────────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(const BranchesSection()),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),

              // ── تواصل معنا ───────────────────────────────────
              SliverToBoxAdapter(
                child: sectionPadding(const ContactUsSection()),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaginatedProductGridBlocBuilder extends StatelessWidget {
  const PaginatedProductGridBlocBuilder({
    super.key,
    required this.isWeb,
    required this.pagePadding,
  });

  final bool isWeb;
  final double pagePadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SliverToBoxAdapter(child: SizedBox()),
          loading: () => SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb
                  ? ResponsiveLayout.horizontalPadding(context)
                  : pagePadding,
              vertical: AppSpacing.sm,
            ),
            sliver: const SliverToBoxAdapter(child: ProductGridSkeleton()),
          ),
          error: (msg) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(msg),
              ),
            ),
          ),
          loaded: (products) => SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb
                  ? ResponsiveLayout.horizontalPadding(context)
                  : pagePadding,
              vertical: AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: PaginatedProductGrid(products: products),
            ),
          ),
        );
      },
    );
  }
}

class CategoryHorizontalStripBlocBuilder extends StatelessWidget {
  const CategoryHorizontalStripBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return state.when(
          initial: () => const CategoryStripSkeleton(),
          loading: () => const CategoryStripSkeleton(),
          error: (_) => const SizedBox(),
          loaded: (cats) => CategoryHorizontalStrip(cats: cats),
        );
      },
    );
  }
}

class IconBagBlocBuilder extends StatelessWidget {
  const IconBagBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final count = state.maybeWhen(
          loaded: (items) => items.fold(0, (sum, item) => sum + item.quantity),
          orElse: () => 0,
        );
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () => context.push(RoutePaths.cart),
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
class _ProductComparisonSection extends StatefulWidget {
  final List<ProductEntity> products;
  const _ProductComparisonSection({required this.products});

  @override
  State<_ProductComparisonSection> createState() =>
      _ProductComparisonSectionState();
}

class _ProductComparisonSectionState extends State<_ProductComparisonSection> {
  late List<ProductEntity> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.products.take(3).toList();
  }

  @override
  void didUpdateWidget(covariant _ProductComparisonSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو قايمة المنتجات اتغيّرت (فلترة، ريفريش...) وأي منتج متختار حاليًا
    // في المقارنة بقى مش موجود، بدّله بأول منتج متاح عشان منوصلش لحالة
    // فيها كارت شايل منتج قديم مش موجود في allProducts.
    final availableIds = widget.products.map((p) => p.id).toSet();
    var changed = false;
    final next = _selected.map((p) {
      if (availableIds.contains(p.id)) return p;
      changed = true;
      return widget.products.first;
    }).toList();
    if (changed) {
      setState(() => _selected = next);
    }
  }

  void _replace(int slot, ProductEntity product) {
    setState(() => _selected[slot] = product);
  }

  @override
  Widget build(BuildContext context) {
    if (_selected.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        border: Border.all(color: AppColors.gold.withOpacity(0.18)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_selected.length, (i) {
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
              child: SizedBox(
                width: 170,
                child: _ComparisonCard(
                  product: _selected[i],
                  allProducts: widget.products,
                  onSwap: (p) => _replace(i, p),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final ProductEntity product;
  final List<ProductEntity> allProducts;
  final ValueChanged<ProductEntity> onSwap;

  const _ComparisonCard({
    required this.product,
    required this.allProducts,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final rating = pseudoRatingFor(p.id);
    final reviews = pseudoReviewCountFor(p.id);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push(RoutePaths.productDetailsPath(p.id)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: p.imageUrls.isNotEmpty
                    ? Image.network(
                        p.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.checkroom_outlined),
                        ),
                      )
                    : Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.checkroom_outlined),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          PriceText(
            p.price,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              RatingStars(rating: rating, size: 12),
              const SizedBox(width: 4),
              Text(
                '($reviews)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          _ComparisonRow(
            label: 'الماركة',
            value: p.brand.isEmpty ? '—' : p.brand,
          ),
          _ComparisonRow(label: 'جديد', value: p.isNew ? 'أيوه' : 'لأ'),
          _ComparisonRow(
            label: 'خصم',
            value: p.isOnSale
                ? '${p.discountPercent.toStringAsFixed(0)}%'
                : 'لا يوجد',
          ),
          const SizedBox(height: 8),
          if (allProducts.length > 1)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  side: BorderSide(color: AppColors.gold.withOpacity(0.5)),
                ),
                onPressed: () => _showSwapSheet(context),
                icon: const Icon(Icons.swap_horiz_rounded, size: 15),
                label: const Text(
                  'غيّر المنتج',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSwapSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _SwapProductSheet(
          currentProductId: product.id,
          allProducts: allProducts,
          onPicked: (item) {
            onSwap(item);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// شيت اختيار منتج بديل للمقارنة — بديل عن ListView.builder اللي كان
// بيستدعي context.money مباشرة جوه itemBuilder، وده اللي كان بيسبب
// الكراش تحديدًا لحظة الضغط على "غيّر المنتج" واختيار بديل.
// ══════════════════════════════════════════════════════════════
class _SwapProductSheet extends StatefulWidget {
  final String currentProductId;
  final List<ProductEntity> allProducts;
  final ValueChanged<ProductEntity> onPicked;

  const _SwapProductSheet({
    required this.currentProductId,
    required this.allProducts,
    required this.onPicked,
  });

  @override
  State<_SwapProductSheet> createState() => _SwapProductSheetState();
}

class _SwapProductSheetState extends State<_SwapProductSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.allProducts
        : widget.allProducts
              .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختار منتج بديل',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'دور على منتج...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('مفيش نتايج'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final item = filtered[i];
                        final isCurrent = item.id == widget.currentProductId;
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 42,
                              height: 42,
                              child: item.imageUrls.isNotEmpty
                                  ? Image.network(
                                      item.imageUrls.first,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.checkroom_outlined),
                                    )
                                  : const Icon(Icons.checkroom_outlined),
                            ),
                          ),
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // كانت هنا Text(context.money(item.price)) بشكل
                          // مباشر جوه itemBuilder — ده اللي كان بيكسر
                          // الشرط بتاع provider. _PriceText بتحل المشكلة
                          // بإنها بتفتح Builder جديد قبل ما تنادي context.money.
                          subtitle: PriceText(item.price),
                          trailing: isCurrent
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.gold,
                                )
                              : null,
                          onTap: isCurrent ? null : () => widget.onPicked(item),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final String value;
  const _ComparisonRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Hero + Offer Carousel (مدموج) — صورة البانر + النص الترويجي +
// الأنيميشن + التغميقة كلهم في PageView واحد بدل التنين اللي كانوا
// قبل كده. فيه "peek" لبداية السلايد الجاي عشان يبان إنه فيه سكرول.
// ══════════════════════════════════════════════════════════════
class _HeroSlideData {
  final String image;
  final String eyebrow;
  final String headline;
  final String sub;
  final Color accent;

  const _HeroSlideData({
    required this.image,
    required this.eyebrow,
    required this.headline,
    required this.sub,
    required this.accent,
  });
}

class _HeroOfferCarousel extends StatefulWidget {
  const _HeroOfferCarousel();

  @override
  State<_HeroOfferCarousel> createState() => _HeroOfferCarouselState();
}

class _HeroOfferCarouselState extends State<_HeroOfferCarousel> {
  late final PageController _ctrl;
  int _page = 0;
  Timer? _timer;

  static const List<Color> _accents = [
    AppColors.gold,
    Color(0xFFFF6B35),
    Color(0xFF6EA8FE),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.92);
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _safeAdvance());
  }

  // بنتأكد إن الـ controller لسه متعلق بشاشة حية قبل ما نستدعي
  // animateToPage، وبنحوط الاستدعاء بـ try/catch كمان: ممكن يحصل تايمنج
  // نادر (مثلاً وقت فتح bottom sheet أو التنقل بين الصفحات) يخلي الـ
  // render object يبقى inactive للحظة فيرمي DartError. الحماية دي
  // بتمنع كراش الصفحة بالكامل في الحالة دي.
  void _safeAdvance() {
    if (!mounted || !_ctrl.hasClients) return;
    try {
      final next = (_page + 1) % _accents.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    } catch (_) {
      // تجاهل بهدوء — هيصحح نفسه في الدورة الجاية من التايمر
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final h = isWeb ? 460.0 : 230.0;

    final slides = <_HeroSlideData>[
      _HeroSlideData(
        image: _kHeroBannerImages[0],
        eyebrow: context.l10n.newArrivals.toUpperCase(),
        headline: context.l10n.exploreCollection.toUpperCase(),
        sub: context.l10n.shopNow,
        accent: _accents[0],
      ),
      _HeroSlideData(
        image: _kHeroBannerImages[1],
        eyebrow: context.l10n.shopNow.toUpperCase(),
        headline: context.l10n.newArrivals.toUpperCase(),
        sub: context.l10n.exploreCollection,
        accent: _accents[1],
      ),
      _HeroSlideData(
        image: _kHeroBannerImages[2],
        eyebrow: context.l10n.explore.toUpperCase(),
        headline: context.l10n.shop.toUpperCase(),
        sub: context.l10n.exploreCollection,
        accent: _accents[2],
      ),
    ];

    return FadeSlideIn(
      child: Column(
        children: [
          SizedBox(
            height: h,
            child: PageView.builder(
              controller: _ctrl,
              itemCount: slides.length,
              onPageChanged: (p) => setState(() => _page = p),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _HeroOfferSlide(data: slides[i], isWeb: isWeb),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (i) {
              final sel = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: sel ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.gold
                      : Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _HeroOfferSlide extends StatelessWidget {
  final _HeroSlideData data;
  final bool isWeb;
  const _HeroOfferSlide({required this.data, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.categories),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isWeb ? 22 : 16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              data.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 40),
                ),
              ),
            ),
            // تغميقة متدرجة عشان النص الترويجي يبان واضح وفخم فوق الصورة
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.78),
                      Colors.black.withOpacity(0.18),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // إطار ذهبي رفيع فخم حوالين السلايد
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isWeb ? 22 : 16),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.35),
                    width: 1.2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isWeb ? AppSpacing.xxl : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: data.accent.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: data.accent.withOpacity(0.4)),
                    ),
                    child: Text(
                      data.eyebrow,
                      style: TextStyle(
                        color: data.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.headline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      height: 1.05,
                      fontSize: isWeb ? 34 : 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.sub,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GlowButton(
                    label: context.l10n.shopNow.toUpperCase(),
                    color: data.accent,
                    onTap: () => context.push(RoutePaths.categories),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Search bar (يفتح صفحة البحث)
// ══════════════════════════════════════════════════════════════
class _SearchBarButton extends StatelessWidget {
  const _SearchBarButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.search),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.6),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Theme.of(context).hintColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'دور على منتجك المفضل...',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Trust badges (شحن / دفع آمن / استرجاع / دعم)
// ══════════════════════════════════════════════════════════════
class _TrustItem {
  final IconData icon;
  final String label;
  const _TrustItem(this.icon, this.label);
}

class _TrustBadgesRow extends StatelessWidget {
  const _TrustBadgesRow();

  static const List<_TrustItem> _items = [
    _TrustItem(Icons.local_shipping_outlined, 'شحن سريع'),
    _TrustItem(Icons.verified_user_outlined, 'دفع آمن'),
    _TrustItem(Icons.autorenew_rounded, 'استرجاع سهل'),
    _TrustItem(Icons.headset_mic_outlined, 'دعم دائم'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items.map((item) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.12),
                  border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                ),
                child: Icon(item.icon, color: AppColors.gold, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Flash sale countdown
// ══════════════════════════════════════════════════════════════
class _FlashSaleBanner extends StatefulWidget {
  const _FlashSaleBanner();

  @override
  State<_FlashSaleBanner> createState() => _FlashSaleBannerState();
}

class _FlashSaleBannerState extends State<_FlashSaleBanner> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _remaining = midnight.difference(now);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final next = _remaining - const Duration(seconds: 1);
        _remaining = next.isNegative ? Duration.zero : next;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;

    return FadeSlideIn(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A0A00), Color(0xFF2E1600)],
          ),
          border: Border.all(color: AppColors.gold.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Color(0xFFFF6B35)),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'عروض اليوم تنتهي خلال',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _TimeChip(value: _two(h)),
            const _Colon(),
            _TimeChip(value: _two(m)),
            const _Colon(),
            _TimeChip(value: _two(s)),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String value;
  const _TimeChip({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: Text(
      ':',
      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
// Best sellers strip
// ══════════════════════════════════════════════════════════════
class _BestSellersStrip extends StatelessWidget {
  final List<ProductEntity> products;
  const _BestSellersStrip({required this.products});

  @override
  Widget build(BuildContext context) {
    final items = products.take(8).toList();
    if (items.isEmpty) return const SizedBox();
    return SizedBox(
      height: 278,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) => SizedBox(
          width: 160,
          child: StaggeredEntrance(
            index: i,
            baseDelay: const Duration(milliseconds: 40),
            child: ProductCard(product: items[i], heroTagPrefix: 'best'),
          ),
        ),
      ),
    );
  }
}
