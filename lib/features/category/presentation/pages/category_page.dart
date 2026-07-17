// features/category/presentation/pages/categories_page.dart
//
// UI-only redesign. CategoryCubit / CategoryState / CategoryEntity and all
// routing/business logic are untouched — only presentation changed.
import 'package:ecommerce_el7out/core/theme/luxory_pallete.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>()..load(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatefulWidget {
  const _CategoriesView();

  @override
  State<_CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = true;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = ResponsiveLayout.horizontalPadding(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.shop.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'List view' : 'Grid view',
            icon: Icon(
              _isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
            ),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => CustomScrollView(
                slivers: [
                  _HeroBanner(collapsed: false),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: pagePadding),
                      child: const _SearchField(enabled: false),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(pagePadding),
                    sliver: _CategoryGridSkeleton(isGrid: _isGrid),
                  ),
                ],
              ),
              error: (msg) => _ErrorState(
                message: msg,
                onRetry: () => context.read<CategoryCubit>().load(),
              ),
              loaded: (cats) {
                final filtered = _query.trim().isEmpty
                    ? cats
                    : cats
                          .where(
                            (c) => c.name.toLowerCase().contains(
                              _query.trim().toLowerCase(),
                            ),
                          )
                          .toList();

                return CustomScrollView(
                  slivers: [
                    const _HeroBanner(collapsed: false),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          pagePadding,
                          0,
                          pagePadding,
                          AppSpacing.md,
                        ),
                        child: _SearchField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: pagePadding),
                        child: _SectionDivider(
                          label: 'تصفح بالاقسام',
                          count: filtered.length,
                        ),
                      ),
                    ),
                    if (filtered.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(query: _query),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          pagePadding,
                          AppSpacing.md,
                          pagePadding,
                          pagePadding * 2,
                        ),
                        sliver: _isGrid
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          ResponsiveLayout.isMobile(context)
                                          ? 2
                                          : 3,
                                      mainAxisSpacing: AppSpacing.md,
                                      crossAxisSpacing: AppSpacing.md,
                                      childAspectRatio: 0.78,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => StaggeredEntrance(
                                    index: i,
                                    child: _LuxuryCategoryCard(
                                      category: filtered[i],
                                    ),
                                  ),
                                  childCount: filtered.length,
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: StaggeredEntrance(
                                      index: i,
                                      child: _LuxuryCategoryListTile(
                                        category: filtered[i],
                                      ),
                                    ),
                                  ),
                                  childCount: filtered.length,
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
}

/// Large collapsing "editorial" hero banner at the top of the categories
/// overview — gold gradient, gauzy scrim, big premium type.
class _HeroBanner extends StatelessWidget {
  final bool collapsed;
  const _HeroBanner({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [LuxuryPalette.ink, LuxuryPalette.inkSoft],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Soft gold glow accents for a "3D" layered feel.
            Positioned(
              top: -60,
              right: -40,
              child: _GlowCircle(size: 220, opacity: 0.16),
            ),
            Positioned(
              bottom: -80,
              left: -30,
              child: _GlowCircle(size: 180, opacity: 0.10),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(gradient: LuxuryPalette.heroScrim),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveLayout.horizontalPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('من أجلك', style: LuxuryPalette.eyebrow(context)),
                    const SizedBox(height: 10),
                    Text(
                      'THE COLLECTION',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'استكشف كل قسم, صنع من اجلك.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            LuxuryPalette.champagne.withOpacity(opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const _SearchField({this.controller, this.onChanged, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 16,
      tint: Colors.white,
      tintOpacity: Theme.of(context).brightness == Brightness.dark
          ? 0.06
          : 0.55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'ابحث عن قسم',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: LuxuryPalette.champagne,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  final int count;
  const _SectionDivider({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LuxuryPalette.champagne.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: LuxuryPalette.champagne,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryCategoryCard extends StatelessWidget {
  final CategoryEntity category;
  const _LuxuryCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () => context.push(RoutePaths.categoryDetailPath(category.slug)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'category-${category.slug}',
              child: category.imageUrl != null
                  ? Image.network(
                      category.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return const ShimmerLoader(
                          height: double.infinity,
                          width: double.infinity,
                        );
                      },
                    )
                  : Container(
                      color: AppColors.lightSurfaceAlt,
                      child: const Icon(Icons.checkroom_outlined, size: 40),
                    ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(gradient: LuxuryPalette.cardScrim),
            ),
            // Frosted glass label plate — the "glassmorphism" panel per card.
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: GlassContainer(
                borderRadius: 14,
                tint: Colors.black,
                tintOpacity: 0.18,
                blurSigma: 12,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                shadows: const [],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.productCount > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.itemsCount(category.productCount),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LuxuryCategoryListTile extends StatelessWidget {
  final CategoryEntity category;
  const _LuxuryCategoryListTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () => context.push(RoutePaths.categoryDetailPath(category.slug)),
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
                width: 76,
                height: 76,
                child: Hero(
                  tag: 'category-${category.slug}',
                  child: category.imageUrl != null
                      ? Image.network(category.imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.lightSurfaceAlt,
                          child: const Icon(Icons.checkroom_outlined),
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
                    category.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (category.productCount > 0) ...[
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.itemsCount(category.productCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: LuxuryPalette.champagne,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridSkeleton extends StatelessWidget {
  final bool isGrid;
  const _CategoryGridSkeleton({required this.isGrid});

  @override
  Widget build(BuildContext context) {
    if (!isGrid) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: ShimmerLoader(
              height: 96,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          childCount: 5,
        ),
      );
    }
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.isMobile(context) ? 2 : 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.78,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => ShimmerLoader(
          height: double.infinity,
          borderRadius: BorderRadius.circular(18),
        ),
        childCount: 6,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 44,
              color: LuxuryPalette.champagne,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              query.trim().isEmpty
                  ? 'لا يوجد اقسام'
                  : 'لا توجد اقسام مشابهه "$query"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_outlined, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(message),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}
