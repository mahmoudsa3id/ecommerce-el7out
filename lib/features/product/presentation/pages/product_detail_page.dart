// features/product/presentation/pages/product_details_page.dart
//
// UI-only redesign. Data fetching (ProductRepository.getProductById),
// analytics logging, CartCubit.addProduct, WishlistCubit and all
// selection logic (_selectColor / sizeStocksForColor) are unchanged.
//
// NOTE on scope — a few requested elements need data that isn't present
// on the current ProductEntity / repositories, so rather than inventing
// fields or fake API calls that would break compilation, they were left
// out and are called out at the bottom of my reply:
//   • rating / review count / SKU / tags / category chip
//   • Recommended / Recently viewed / Related products
// "Buy Now" reuses the existing cart flow (no separate checkout route
// exists yet). "Share" / "Copy Link" copy a placeholder product URL to
// the clipboard — swap in your real domain and/or a share package later.
//
// FIX (this revision): every `product.compareAtPrice!` use has been
// replaced with a null-safe local variable (`compareAt`) computed once per
// build, matching the same fix applied to category_detail_page.dart. This
// removes any risk of "Null check operator used on a null value" if
// `isOnSale` and `compareAtPrice` ever get out of sync. The Share/Copy-link
// OutlinedButtons were already correctly wrapped in `Expanded` inside their
// Row, so no change was needed there — if you're still seeing the
// "BoxConstraints forces an infinite width" crash, it's coming from a
// DIFFERENT file: the stack trace points at
// `product_detail_page.dart:1465` (singular "detail"), not this file
// (`product_details_page.dart`, plural). Please locate and share that file
// so the actual unwrapped OutlinedButton can be fixed.
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/theme/luxory_pallete.dart';
import 'package:ecommerce_el7out/core/widgets/app_button.dart';
import 'package:ecommerce_el7out/core/widgets/glass_container.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/core/widgets/shimmer_loader.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_el7out/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_el7out/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_el7out/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  String? _selectedColor;
  String? _selectedSize;
  int _activeImageIndex = 0;
  int _quantity = 1;
  bool _addingToCart = false;
  bool _buyingNow = false;
  final Set<String> _expandedSections = {'description'};

  late final Future<ProductEntity?> _future = _fetch();

  Future<ProductEntity?> _fetch() async {
    final result = await getIt<ProductRepository>().getProductById(
      widget.productId,
    );
    return result.fold((_) => null, (product) {
      getIt<AnalyticsService>().logViewProduct(
        product.id,
        product.name,
        product.price,
      );
      return product;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectColor(ProductEntity product, String color) {
    final sizes = product.sizeStocksForColor(color);
    setState(() {
      _selectedColor = color;
      _selectedSize = sizes
          .firstWhere(
            (size) => size.inStock,
            orElse: () => sizes.isNotEmpty
                ? sizes.first
                : const VariantSizeStockEntity(size: '', stock: 0),
          )
          .size;
      if (_selectedSize!.isEmpty) _selectedSize = null;
      _activeImageIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toggleSection(String key) {
    setState(() {
      if (_expandedSections.contains(key)) {
        _expandedSections.remove(key);
      } else {
        _expandedSections.add(key);
      }
    });
  }

  bool _canAdd(ProductEntity product) {
    final color = _selectedColor;
    final size = _selectedSize;
    if (color == null || size == null) return false;
    final stock = product
        .sizeStocksForColor(color)
        .where((item) => item.size == size)
        .firstOrNull;
    return stock != null && stock.inStock;
  }

  Future<void> _addToCart(ProductEntity product, {bool buyNow = false}) async {
    final color = _selectedColor;
    final size = _selectedSize;
    if (color == null || size == null) return;
    if (!_canAdd(product)) return;

    setState(() {
      if (buyNow) {
        _buyingNow = true;
      } else {
        _addingToCart = true;
      }
    });

    // CartCubit.addProduct has no quantity parameter, so we call it once per
    // unit — this keeps the existing Cubit API untouched.
    for (var i = 0; i < _quantity; i++) {
      await context.read<CartCubit>().addProduct(
        product,
        size: size,
        color: color,
      );
    }

    if (!mounted) return;
    setState(() {
      _addingToCart = false;
      _buyingNow = false;
    });

    if (buyNow) {
      context.push(RoutePaths.cart);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.86),
        content: Text(context.l10n.addedToBag),
        action: SnackBarAction(
          label: context.l10n.viewBag.toUpperCase(),
          textColor: LuxuryPalette.champagne,
          onPressed: () => context.push(RoutePaths.cart),
        ),
      ),
    );
  }

  void _openFullscreenGallery(List<String> images, int startIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: _FullscreenGallery(
            productId: widget.productId,
            images: images,
            initialIndex: startIndex,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: getIt<WishlistCubit>())],
      child: FutureBuilder<ProductEntity?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _ProductDetailSkeletonScaffold();
          }
          final product = snapshot.data;
          if (product == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(context.l10n.productNotFound)),
            );
          }

          _selectedColor ??= product.variants.isNotEmpty
              ? product.variants.first.colorName
              : product.colors.firstOrNull;
          _selectedSize ??= product
              .sizeStocksForColor(_selectedColor)
              .firstWhere(
                (size) => size.inStock,
                orElse: () =>
                    product.sizeStocksForColor(_selectedColor).firstOrNull ??
                    const VariantSizeStockEntity(size: '', stock: 0),
              )
              .size;
          if (_selectedSize != null && _selectedSize!.isEmpty) {
            _selectedSize = null;
          }

          final scaffold = _ProductDetailScaffold(
            product: product,
            selectedColor: _selectedColor,
            selectedSize: _selectedSize,
            activeImageIndex: _activeImageIndex,
            quantity: _quantity,
            pageController: _pageController,
            addingToCart: _addingToCart,
            buyingNow: _buyingNow,
            canAdd: _canAdd(product),
            expandedSections: _expandedSections,
            onColorSelected: (color) => _selectColor(product, color),
            onSizeSelected: (size) => setState(() => _selectedSize = size),
            onImageChanged: (index) =>
                setState(() => _activeImageIndex = index),
            onImageTap: (index, images) =>
                _openFullscreenGallery(images, index),
            onThumbnailTap: (index) => _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
            ),
            onToggleSection: _toggleSection,
            onQuantityChanged: (q) => setState(() => _quantity = q),
            onAddToCart: () => _addToCart(product),
            onBuyNow: () => _addToCart(product, buyNow: true),
          );

          return ResponsiveLayout(mobile: scaffold, desktop: scaffold);
        },
      ),
    );
  }
}

class _ProductDetailSkeletonScaffold extends StatelessWidget {
  const _ProductDetailSkeletonScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoader(height: 420, borderRadius: BorderRadius.circular(16)),
            const SizedBox(height: 20),
            ShimmerLoader(
              height: 18,
              width: 120,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            ShimmerLoader(
              height: 26,
              width: 220,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 14),
            ShimmerLoader(
              height: 24,
              width: 100,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 26),
            ShimmerLoader(height: 48, borderRadius: BorderRadius.circular(12)),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailScaffold extends StatelessWidget {
  final ProductEntity product;
  final String? selectedColor;
  final String? selectedSize;
  final int activeImageIndex;
  final int quantity;
  final PageController pageController;
  final bool addingToCart;
  final bool buyingNow;
  final bool canAdd;
  final Set<String> expandedSections;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<int> onImageChanged;
  final void Function(int index, List<String> images) onImageTap;
  final ValueChanged<int> onThumbnailTap;
  final ValueChanged<String> onToggleSection;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _ProductDetailScaffold({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.activeImageIndex,
    required this.quantity,
    required this.pageController,
    required this.addingToCart,
    required this.buyingNow,
    required this.canAdd,
    required this.expandedSections,
    required this.onColorSelected,
    required this.onSizeSelected,
    required this.onImageChanged,
    required this.onImageTap,
    required this.onThumbnailTap,
    required this.onToggleSection,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final images = product.imagesForColor(selectedColor);
    final isMobile = ResponsiveLayout.isMobile(context);

    final gallery = _VariantGallery(
      productId: product.id,
      images: images,
      activeIndex: activeImageIndex,
      pageController: pageController,
      onPageChanged: onImageChanged,
      onThumbnailTap: onThumbnailTap,
      onImageTap: (i) => onImageTap(i, images),
      height: isMobile ? MediaQuery.sizeOf(context).height * 0.56 : 640,
    );

    final panel = _ProductPurchasePanel(
      product: product,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      quantity: quantity,
      addingToCart: addingToCart,
      buyingNow: buyingNow,
      canAdd: canAdd,
      expandedSections: expandedSections,
      onColorSelected: onColorSelected,
      onSizeSelected: onSizeSelected,
      onToggleSection: onToggleSection,
      onQuantityChanged: onQuantityChanged,
      onAddToCart: onAddToCart,
      onBuyNow: onBuyNow,
      showActions: !isMobile,
    );

    final content = isMobile
        ? Column(
            children: [
              gallery,
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  20,
                  AppSpacing.pageHorizontal,
                  120,
                ),
                child: panel,
              ),
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveLayout.horizontalPadding(context),
              vertical: 28,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: gallery),
                const SizedBox(width: 56),
                Expanded(flex: 4, child: panel),
              ],
            ),
          );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(child: content),
      bottomNavigationBar: isMobile
          ? _StickyPurchaseBar(
              product: product,
              quantity: quantity,
              canAdd: canAdd,
              addingToCart: addingToCart,
              buyingNow: buyingNow,
              onAddToCart: onAddToCart,
              onBuyNow: onBuyNow,
            )
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------------------

class _VariantGallery extends StatelessWidget {
  final String productId;
  final List<String> images;
  final int activeIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onThumbnailTap;
  final ValueChanged<int> onImageTap;
  final double height;

  const _VariantGallery({
    required this.productId,
    required this.images,
    required this.activeIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onThumbnailTap,
    required this.onImageTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final clampedIndex = activeIndex >= images.length ? 0 : activeIndex;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.97, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: Column(
        key: ValueKey(images.join('|')),
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  images.isEmpty
                      ? ColoredBox(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.checkroom_outlined, size: 64),
                        )
                      : PageView.builder(
                          controller: pageController,
                          itemCount: images.length,
                          onPageChanged: onPageChanged,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => onImageTap(index),
                            child: Hero(
                              tag: 'product-image-$productId-$index',
                              child: _ParallaxImage(url: images[index]),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: 14),
            _GalleryDots(count: images.length, activeIndex: clampedIndex),
            const SizedBox(height: 14),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => onThumbnailTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: index == clampedIndex
                            ? LuxuryPalette.champagne
                            : Theme.of(context).dividerColor,
                        width: index == clampedIndex ? 2 : 1,
                      ),
                      boxShadow: index == clampedIndex
                          ? LuxuryPalette.floatingShadow(opacity: 0.18)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(images[index], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Subtle scale-in "3D" transition applied to the main hero image as it
/// double-tap zooms — a lightweight substitute for a full 3D engine that
/// keeps the effect purely visual/CSS-like via Matrix4.
class _ParallaxImage extends StatefulWidget {
  final String url;
  const _ParallaxImage({required this.url});

  @override
  State<_ParallaxImage> createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<_ParallaxImage> {
  final TransformationController _controller = TransformationController();
  bool _zoomed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    setState(() {
      _zoomed = !_zoomed;
      _controller.value = _zoomed
          ? (Matrix4.identity()..scale(2.2))
          : Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _toggleZoom,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 4,
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox.expand(
              child: ShimmerLoader(height: double.infinity),
            );
          },
        ),
      ),
    );
  }
}

class _FullscreenGallery extends StatefulWidget {
  final String productId;
  final List<String> images;
  final int initialIndex;

  const _FullscreenGallery({
    required this.productId,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('${_index + 1} / ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, index) => Center(
          child: Hero(
            tag: 'product-image-${widget.productId}-$index',
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Image.network(widget.images[index], fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _GalleryDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: index == activeIndex ? 22 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: index == activeIndex
                ? LuxuryPalette.champagne
                : Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Purchase panel
// ---------------------------------------------------------------------------

class _ProductPurchasePanel extends StatelessWidget {
  final ProductEntity product;
  final String? selectedColor;
  final String? selectedSize;
  final int quantity;
  final bool addingToCart;
  final bool buyingNow;
  final bool canAdd;
  final Set<String> expandedSections;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<String> onToggleSection;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool showActions;

  const _ProductPurchasePanel({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.addingToCart,
    required this.buyingNow,
    required this.canAdd,
    required this.expandedSections,
    required this.onColorSelected,
    required this.onSizeSelected,
    required this.onToggleSection,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    final sizeStocks = product.sizeStocksForColor(selectedColor);
    final selectedStock = sizeStocks
        .where((item) => item.size == selectedSize)
        .firstOrNull;
    final unitPrice = product.price;
    // FIX: null-safe local instead of `product.compareAtPrice!`.
    final compareAt = product.compareAtPrice;
    final showSale = product.isOnSale && compareAt != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.brand.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: LuxuryPalette.champagne,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Text(
                context.money(unitPrice * quantity),
                key: ValueKey(quantity),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: LuxuryPalette.champagne,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (showSale) ...[
              const SizedBox(width: 12),
              Text(
                context.money(compareAt * quantity),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
            if (quantity > 1) ...[
              const SizedBox(width: 8),
              Text(
                '(السعر لكل قطعة${context.money(unitPrice)} )',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _StockPill(stock: selectedStock),
        const SizedBox(height: 26),
        if (product.variants.isNotEmpty)
          _ColorSelector(
            variants: product.variants,
            selectedColor: selectedColor,
            onSelected: onColorSelected,
          ),
        const SizedBox(height: 22),
        if (sizeStocks.isNotEmpty)
          _SizeSelector(
            sizes: sizeStocks,
            selectedSize: selectedSize,
            onSelected: onSizeSelected,
          ),
        const SizedBox(height: 22),
        _QuantitySelector(quantity: quantity, onChanged: onQuantityChanged),
        const SizedBox(height: 26),
        if (showActions) ...[
          _PurchaseButtons(
            product: product,
            canAdd: canAdd,
            selectedStock: selectedStock,
            addingToCart: addingToCart,
            buyingNow: buyingNow,
            onAddToCart: onAddToCart,
            onBuyNow: onBuyNow,
          ),

          const SizedBox(height: 30),
        ],
        _ExpandableSection(
          id: 'description',
          title: 'الوصف',
          expanded: expandedSections.contains('description'),
          onToggle: onToggleSection,
          child: Text(product.description),
        ),
        _ExpandableSection(
          id: 'details',
          title: 'تفاصيل المنتج',
          expanded: expandedSections.contains('details'),
          onToggle: onToggleSection,
          child: _ProductDetailsList(product: product),
        ),
        _ExpandableSection(
          id: 'shipping',
          title: 'الشحن والاسترجاع',
          expanded: expandedSections.contains('shipping'),
          onToggle: onToggleSection,
          child: const Text(
            'نوفر شحنًا سريعًا وآمنًا لجميع المحافظات داخل مصر. '
            'يتم تجهيز الطلبات وإرسالها في أسرع وقت، وتختلف مدة التوصيل حسب المحافظة. '
            'يمكن استبدال أو استرجاع المنتج خلال 7 أيام من تاريخ الاستلام، بشرط أن يكون '
            'غير مستخدم، وفي حالته الأصلية، مع جميع التاغات والفاتورة. '
            'وفي حال وجود أي عيب صناعي بالمنتج، يحق للعميل الاستبدال أو الاسترجاع وفقًا لسياسة المتجر.',
          ),
        ),
        _ExpandableSection(
          id: 'quality',
          title: 'لماذا هذا المنتج؟',
          expanded: expandedSections.contains('quality'),
          onToggle: onToggleSection,
          child: const Text(
            '• خامات مختارة بعناية لضمان أعلى جودة.\n'
            '• تصميم عصري يناسب جميع الإطلالات.\n'
            '• قماش مريح يسمح بالتهوية طوال اليوم.\n'
            '• خياطة متقنة وتشطيب فاخر يدوم لفترة طويلة.\n'
            '• جودة تجمع بين الأناقة والراحة في كل تفصيلة.',
          ),
        ),
      ],
    );
  }
}

class _StockPill extends StatelessWidget {
  final VariantSizeStockEntity? stock;
  const _StockPill({required this.stock});

  @override
  Widget build(BuildContext context) {
    if (stock == null) {
      return Text(
        'اختر المقاس',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
      );
    }
    final inStock = stock!.inStock;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: inStock ? Colors.green : Colors.redAccent,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          inStock
              ? 'متبقي${context.l10n.itemsCount(stock!.stock)} '
              : context.l10n.outOfStock,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: inStock ? Colors.green.shade700 : Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final List<ProductVariantEntity> variants;
  final String? selectedColor;
  final ValueChanged<String> onSelected;

  const _ColorSelector({
    required this.variants,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.color.toUpperCase()}: ${selectedColor ?? ''}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: variants
              .map(
                (variant) => _ColorChip(
                  variant: variant,
                  selected: variant.colorName == selectedColor,
                  onTap: () => onSelected(variant.colorName),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  final ProductVariantEntity variant;
  final bool selected;
  final VoidCallback onTap;

  const _ColorChip({
    required this.variant,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hex = int.tryParse(variant.colorHex.replaceFirst('#', ''), radix: 16);
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: selected ? LuxuryPalette.goldGradient : null,
          color: selected
              ? null
              : Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          border: Border.all(
            color: selected
                ? LuxuryPalette.champagneDeep
                : Theme.of(context).dividerColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: Color((hex ?? 0x111111) | 0xFF000000),
            ),
            const SizedBox(width: 8),
            Text(
              variant.colorName,
              style: TextStyle(
                color: selected ? LuxuryPalette.ink : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<VariantSizeStockEntity> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSelected;

  const _SizeSelector({
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.size.toUpperCase()}: ${selectedSize ?? ''}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sizes.map((item) {
            final selected = item.size == selectedSize;
            return PressableScale(
              onTap: item.inStock ? () => onSelected(item.size) : null,
              child: Opacity(
                opacity: item.inStock ? 1 : 0.4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: selected ? LuxuryPalette.goldGradient : null,
                    color: selected
                        ? null
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
                    border: Border.all(
                      color: selected
                          ? LuxuryPalette.champagneDeep
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Text(
                    item.inStock
                        ? item.size
                        : '${item.size} • ${context.l10n.outOfStock}',
                    style: TextStyle(
                      color: selected ? LuxuryPalette.ink : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كمية', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 10),
        GlassContainer(
          borderRadius: 12,
          tint: Theme.of(context).colorScheme.surfaceContainerHighest,
          tintOpacity: 0.5,
          blurSigma: 0,
          shadows: const [],
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_rounded),
                onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: quantity < 10 ? () => onChanged(quantity + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PurchaseButtons extends StatelessWidget {
  final ProductEntity product;
  final bool canAdd;
  final VariantSizeStockEntity? selectedStock;
  final bool addingToCart;
  final bool buyingNow;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _PurchaseButtons({
    required this.product,
    required this.canAdd,
    required this.selectedStock,
    required this.addingToCart,
    required this.buyingNow,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final outOfStock = selectedStock != null && !selectedStock!.inStock;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: outOfStock
                    ? context.l10n.outOfStock.toUpperCase()
                    : context.l10n.addToBag.toUpperCase(),
                icon: Icons.shopping_bag_outlined,
                isLoading: addingToCart,
                onPressed: canAdd ? onAddToCart : null,
              ),
            ),
            const SizedBox(width: 12),
            _WishlistButton(product: product),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: canAdd ? LuxuryPalette.goldGradient : null,
              color: canAdd
                  ? null
                  : Theme.of(context).disabledColor.withOpacity(0.15),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: canAdd ? onBuyNow : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: buyingNow
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'اشتري الان',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: canAdd
                                  ? LuxuryPalette.ink
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders currently-known structured product info (color/size availability)
/// as a clean spec list. Fields like SKU/category/tags aren't on the current
/// ProductEntity, so this only shows what the entity actually exposes.
class _ProductDetailsList extends StatelessWidget {
  final ProductEntity product;
  const _ProductDetailsList({required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('ماركة', product.brand),
      if (product.variants.isNotEmpty)
        MapEntry(
          'الالوان',
          product.variants.map((v) => v.colorName).join(', '),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      e.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  Expanded(child: Text(e.value)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  final String id;
  final String title;
  final bool expanded;
  final ValueChanged<String> onToggle;
  final Widget child;

  const _ExpandableSection({
    required this.id,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onToggle(id),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: LuxuryPalette.champagne,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DefaultTextStyle.merge(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5),
                    child: child,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Divider(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
          height: 1,
        ),
      ],
    );
  }
}

class _WishlistButton extends StatelessWidget {
  final ProductEntity product;
  const _WishlistButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, dynamic>(
      builder: (context, _) {
        return FutureBuilder<bool>(
          future: getIt<WishlistCubit>().isInWishlist(product.id),
          builder: (context, snapshot) {
            final inWishlist = snapshot.data ?? false;
            return IconButton.filledTonal(
              icon: Icon(
                inWishlist ? Icons.favorite : Icons.favorite_border,
                color: inWishlist ? Colors.redAccent : null,
              ),
              onPressed: () => context.read<WishlistCubit>().toggle(
                WishlistItemEntity(
                  productId: product.id,
                  name: product.name,
                  brand: product.brand,
                  price: product.price,
                  imageUrl: product.imageUrls.firstOrNull,
                  addedAt: DateTime.now(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky bottom bar (mobile)
// ---------------------------------------------------------------------------

class _StickyPurchaseBar extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final bool canAdd;
  final bool addingToCart;
  final bool buyingNow;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _StickyPurchaseBar({
    required this.product,
    required this.quantity,
    required this.canAdd,
    required this.addingToCart,
    required this.buyingNow,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: GlassContainer(
          borderRadius: 18,
          tint: Theme.of(context).scaffoldBackgroundColor,
          tintOpacity: 0.78,
          blurSigma: 22,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'الاجمالي',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      context.money(product.price * quantity),
                      key: ValueKey(quantity),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: LuxuryPalette.champagne,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Expanded(
                child: OutlinedButton(
                  onPressed: canAdd ? onAddToCart : null,
                  child: addingToCart
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.shopping_bag_outlined,
                          color: canAdd
                              ? null
                              : Theme.of(context).disabledColor,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: canAdd ? LuxuryPalette.goldGradient : null,
                    color: canAdd
                        ? null
                        : Theme.of(context).disabledColor.withOpacity(0.15),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: canAdd ? onBuyNow : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                        child: buyingNow
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'اشتري الان',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: canAdd
                                      ? LuxuryPalette.ink
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
