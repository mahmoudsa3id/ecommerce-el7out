// ============================================================
// features/cart/presentation/pages/cart_page.dart  (ENHANCED)
// ============================================================
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>()..loadCart(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final pad = isWeb
        ? ResponsiveLayout.horizontalPadding(context)
        : ResponsiveLayout.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CartCubit, CartState>(
          builder: (_, state) {
            final count = state.itemCount;
            return Text(
              count > 0
                  ? context.l10n.myBagCount(count).toUpperCase()
                  : context.l10n.myBag.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(letterSpacing: 2.5),
            );
          },
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => _CartSkeleton(pad: pad),
            error: (msg) => Center(child: Text(msg)),
            loaded: (items) => items.isEmpty
                ? const _EmptyCart()
                : isWeb
                ? _WebCartLayout(items: items, pad: pad)
                : _MobileCartLayout(items: items),
          );
        },
      ),
    );
  }
}

// ── Web two-column cart layout ─────────────────────────────────
class _WebCartLayout extends StatelessWidget {
  final List<CartItemEntity> items;
  final double pad;

  const _WebCartLayout({required this.items, required this.pad});

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold(0.0, (s, i) => s + i.subtotal);
    final shipping = subtotal >= 150 ? 0.0 : 9.99;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left – item list
        Expanded(
          flex: 6,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: pad,
              vertical: AppSpacing.xl,
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => StaggeredListEntrance(
              index: i,
              child: _CartTile(item: items[i]),
            ),
          ),
        ),
        // Right – order summary sticky
        SizedBox(
          width: 340,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, AppSpacing.xl, pad, 0),
            child: _WebOrderSummary(
              subtotal: subtotal,
              shipping: shipping,
              total: subtotal + shipping,
            ),
          ),
        ),
      ],
    );
  }
}

class _WebOrderSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const _WebOrderSummary({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderSummary.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          _Row(l10n.subtotal, context.money(subtotal)),
          const SizedBox(height: 10),
          _Row(
            l10n.shipping,
            shipping == 0 ? l10n.free : context.money(shipping),
          ),
          const Divider(height: 28),
          _Row(l10n.total, context.money(total), bold: true),
          if (subtotal < 150) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: subtotal / 150,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.outline.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addForFreeShipping(context.money(150 - subtotal)),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: l10n.proceedToCheckout.toUpperCase(),
            onPressed: () => context.push(RoutePaths.checkout),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 13),
              const SizedBox(width: 4),
              Text(l10n.secureCheckout, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: style?.copyWith(color: bold ? AppColors.gold : null),
        ),
      ],
    );
  }
}

// ── Mobile cart layout ─────────────────────────────────────────
class _MobileCartLayout extends StatelessWidget {
  final List<CartItemEntity> items;
  const _MobileCartLayout({required this.items});

  @override
  Widget build(BuildContext context) {
    final pagePadding = ResponsiveLayout.horizontalPadding(context);
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(pagePadding),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => StaggeredListEntrance(
              index: i,
              child: _CartTile(item: items[i]),
            ),
          ),
        ),
        _MobileCartBottom(items: items),
      ],
    );
  }
}

class _MobileCartBottom extends StatelessWidget {
  final List<CartItemEntity> items;
  const _MobileCartBottom({required this.items});

  @override
  Widget build(BuildContext context) {
    final pagePadding = ResponsiveLayout.horizontalPadding(context);
    final subtotal = items.fold(0.0, (s, i) => s + i.subtotal);
    final shipping = subtotal >= 150 ? 0.0 : 9.99;
    final total = subtotal + shipping;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(pagePadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (subtotal < 150) ...[
              LinearProgressIndicator(
                value: subtotal / 150,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.outline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.addForFreeShipping(context.money(150 - subtotal)),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.total.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  context.money(total),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.gold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppButton(
              label: l10n.checkout.toUpperCase(),
              onPressed: () => context.push(RoutePaths.checkout),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItemEntity item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final isWeb = ResponsiveLayout.isWeb(context);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error.withOpacity(0.08),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => cubit.removeItem(item.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      width: isWeb ? 100 : 88,
                      height: isWeb ? 120 : 108,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 88,
                      height: 108,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.checkroom_outlined),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Pill(item.selectedSize),
                      const SizedBox(width: 6),
                      _Pill(item.selectedColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.money(item.subtotal),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.gold),
                      ),
                      _QtyControl(item: item, cubit: cubit),
                    ],
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

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final CartItemEntity item;
  final CartCubit cubit;
  const _QtyControl({required this.item, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QBtn(
          Icons.remove,
          () => cubit.updateQuantity(item.id, item.quantity - 1),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: SizedBox(
            width: 32,
            key: ValueKey(item.quantity),
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        _QBtn(
          Icons.add,
          () => cubit.updateQuantity(item.id, item.quantity + 1),
        ),
      ],
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  final double pad;
  const _CartSkeleton({required this.pad});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
      itemCount: 3,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            ShimmerLoader(
              height: 108,
              width: 88,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerLoader(height: 11, width: 70),
                  SizedBox(height: 6),
                  ShimmerLoader(height: 16, width: 180),
                  SizedBox(height: 10),
                  ShimmerLoader(height: 11, width: 100),
                  SizedBox(height: 12),
                  ShimmerLoader(height: 16, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeSlideIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleIn(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: const Icon(Icons.shopping_bag_outlined, size: 44),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.emptyCart,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.emptyCartSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () => context.go(RoutePaths.home),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(context.l10n.continueShopping.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
