import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';

class PaginatedProductGrid extends StatefulWidget {
  final List<ProductEntity> products;
  const PaginatedProductGrid({super.key, required this.products});

  @override
  State<PaginatedProductGrid> createState() => PaginatedProductGridState();
}

class PaginatedProductGridState extends State<PaginatedProductGrid> {
  static const int _pageSize = 6;
  int _currentPage = 0;

  int get _totalPages =>
      widget.products.isEmpty ? 1 : (widget.products.length / _pageSize).ceil();

  List<ProductEntity> get _pageItems {
    final start = _currentPage * _pageSize;
    if (start >= widget.products.length) return const [];
    final end = (start + _pageSize).clamp(0, widget.products.length);
    return widget.products.sublist(start, end);
  }

  @override
  void didUpdateWidget(covariant PaginatedProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو عدد المنتجات اتغيّر (مثلاً بعد فلترة) ورجع الصفحة الحالية بقت
    // خارج النطاق، ارجع لأول صفحة بدل ما يفضل شاشة فاضية.
    if (_currentPage >= _totalPages) {
      setState(() => _currentPage = 0);
    }
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _totalPages || page == _currentPage) return;
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    final items = _pageItems;
    if (items.isEmpty) {
      return const _EmptyProductsState();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: GridView.builder(
            key: ValueKey(_currentPage),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveLayout.gridColumns(context),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.60,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => StaggeredEntrance(
              index: i,
              child: PerspectiveTilt(
                child: ProductCard(
                  product: items[i],
                  heroTagPrefix: 'arrivals',
                ),
              ),
            ),
          ),
        ),
        if (_totalPages > 1) ...[
          const SizedBox(height: AppSpacing.lg),
          _PageNumberBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPageSelected: _goToPage,
          ),
        ],
      ],
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 10),
          Text(
            'مفيش منتجات هنا حاليًا',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageNumberBar extends StatelessWidget {
  final int currentPage; // 0-indexed
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  const _PageNumberBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  List<int?> _buildPageList() {
    if (totalPages <= 5) {
      return List.generate(totalPages, (i) => i);
    }
    final pages = <int>{0, totalPages - 1, currentPage};
    if (currentPage - 1 >= 0) pages.add(currentPage - 1);
    if (currentPage + 1 < totalPages) pages.add(currentPage + 1);
    final sorted = pages.toList()..sort();
    final result = <int?>[];
    for (var i = 0; i < sorted.length; i++) {
      result.add(sorted[i]);
      if (i < sorted.length - 1 && sorted[i + 1] - sorted[i] > 1) {
        result.add(null);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPageList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: currentPage > 0
              ? () => onPageSelected(currentPage - 1)
              : null,
        ),
        ...pages.map((p) {
          if (p == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('…', style: TextStyle(fontWeight: FontWeight.w700)),
            );
          }
          final selected = p == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onPageSelected(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.gold
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  '${p + 1}',
                  style: TextStyle(
                    color: selected
                        ? Colors.black
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: currentPage < totalPages - 1
              ? () => onPageSelected(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
