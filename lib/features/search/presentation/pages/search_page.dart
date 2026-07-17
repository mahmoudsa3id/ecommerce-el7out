// ============================================================
// features/search/presentation/pages/search_page.dart  (ENHANCED)
// ============================================================
import 'dart:async';
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/home_pages.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../product/domain/repositories/product_repository.dart';

const _kRecentSearches = [
  'سوت',
  'بوكس فيت',
  'تشرت',
  'جينز',
  'بانس',
  'شورت',
  'هودي',
  'جاكت',
  'تانك توب',
];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  List<ProductEntity>? _results;
  bool _loading = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() {
        _results = null;
        _loading = false;
        _lastQuery = '';
      });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(q));
  }

  Future<void> _search(String q) async {
    if (q == _lastQuery) {
      setState(() => _loading = false);
      return;
    }
    _lastQuery = q;
    getIt<AnalyticsService>().logSearch(q);
    final result = await getIt<ProductRepository>().searchProducts(q);
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _results = [];
        _loading = false;
      }),
      (products) => setState(() {
        _results = products;
        _loading = false;
      }),
    );
  }

  void _clearAndDismiss() {
    _ctrl.clear();
    setState(() {
      _results = null;
      _loading = false;
      _lastQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final pad = isWeb
        ? ResponsiveLayout.horizontalPadding(context)
        : AppSpacing.pageHorizontal.toDouble();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 12, pad, 0),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _focus.hasFocus
                            ? [
                                BoxShadow(
                                  color: AppColors.gold.withOpacity(0.15),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focus,
                        onChanged: _onChanged,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _search,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: context.l10n.searchHint,
                          prefixIcon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _loading
                                ? Padding(
                                    key: const ValueKey('loading'),
                                    padding: const EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.search,
                                    key: ValueKey('icon'),
                                    size: 20,
                                  ),
                          ),
                          suffixIcon: _ctrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: _clearAndDismiss,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.home),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    child: Text(context.l10n.cancel),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                child: _results == null
                    ? _SearchLandingState(
                        onTap: (q) {
                          _ctrl.text = q;
                          _search(q);
                        },
                      )
                    : _results!.isEmpty
                    ? _NoResults(query: _lastQuery)
                    : _SearchResults(results: _results!, horizontalPad: pad),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchLandingState extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _SearchLandingState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          FadeSlideIn(
            child: Text(
              context.l10n.trendingSearches.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              _kRecentSearches.length,
              (i) => StaggeredEntrance(
                index: i,
                child: _TrendChip(
                  label: _kRecentSearches[i],
                  onTap: () => onTap(_kRecentSearches[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _TrendChip({required this.label, required this.onTap});

  @override
  State<_TrendChip> createState() => _TrendChipState();
}

class _TrendChipState extends State<_TrendChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.gold.withOpacity(0.12)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppColors.gold
                  : Theme.of(context).colorScheme.outline,
              width: _hovered ? 1.2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: 14,
                color: _hovered ? AppColors.gold : null,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _hovered ? AppColors.gold : null,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<ProductEntity> results;
  final double horizontalPad;

  const _SearchResults({required this.results, required this.horizontalPad});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: AppSpacing.md,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.gridColumns(context),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.60,
      ),
      itemCount: results.length,
      itemBuilder: (context, i) => StaggeredEntrance(
        index: i,
        child: ProductCard(product: results[i]),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeSlideIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleIn(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: const Icon(Icons.search_off_rounded, size: 40),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.noResultsFor(query),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.tryDifferentKeywords,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
