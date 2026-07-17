// features/orders/presentation/pages/order_detail_page.dart
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/features/order/domain/repository/order_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../domain/entities/order_entity.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late final Future<OrderEntity?> _future = _load();

  Future<OrderEntity?> _load() async {
    final result = await getIt<OrderRepository>().getOrderById(widget.orderId);
    return result.fold((_) => null, (order) => order);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderDetails.toUpperCase())),
      body: AnimatedPageWrapper(
        child: FutureBuilder<OrderEntity?>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final order = snap.data;
            if (order == null) {
              return Center(child: Text(l10n.orderNotFound));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderStatusTimeline(status: order.status),
                  const SizedBox(height: AppSpacing.xl),
                  _InfoSection(
                    title: l10n.items.toUpperCase(),
                    child: Column(
                      children: order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              if (item.productImageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    item.productImageUrl!,
                                    width: 56,
                                    height: 68,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      l10n.itemDetails(
                                        item.selectedSize,
                                        item.selectedColor,
                                        item.quantity,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                context.money(item.totalPrice),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InfoSection(
                    title: l10n.shippingTo.toUpperCase(),
                    child: Text(
                      '${order.shippingAddress.fullName}\n${order.shippingAddress.formatted}\n${order.shippingAddress.phoneNumber}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InfoSection(
                    title: l10n.paymentSummary.toUpperCase(),
                    child: Column(
                      children: [
                        _SummaryLine(
                          l10n.subtotal,
                          context.money(order.pricing.subtotal),
                        ),
                        const SizedBox(height: 6),
                        _SummaryLine(
                          l10n.shipping,
                          order.pricing.shipping == 0
                              ? l10n.free
                              : context.money(order.pricing.shipping),
                        ),
                        const Divider(height: 20),
                        _SummaryLine(
                          l10n.total,
                          context.money(order.pricing.total),
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusTimeline({required this.status});

  static const _steps = [
    OrderStatus.confirmed,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              context.l10n.orderCancelled,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final currentIdx = _steps.indexOf(status);
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIdx = i ~/ 2;
          final completed = stepIdx < currentIdx;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2,
              color: completed
                  ? AppColors.gold
                  : Theme.of(context).colorScheme.outline,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final completed = stepIdx <= currentIdx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? AppColors.gold : Colors.transparent,
                border: Border.all(
                  color: completed
                      ? AppColors.gold
                      : Theme.of(context).colorScheme.outline,
                  width: 1.5,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(context, _steps[stepIdx]).toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      }),
    );
  }

  String _statusLabel(BuildContext context, OrderStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case OrderStatus.pending:
        return l10n.pending;
      case OrderStatus.confirmed:
        return l10n.confirmed;
      case OrderStatus.processing:
        return l10n.processing;
      case OrderStatus.shipped:
        return l10n.shipped;
      case OrderStatus.delivered:
        return l10n.delivered;
      case OrderStatus.cancelled:
        return l10n.cancelled;
    }
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryLine(this.label, this.value, {this.bold = false});

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
