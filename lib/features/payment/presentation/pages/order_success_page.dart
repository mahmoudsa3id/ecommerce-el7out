// ============================================================
// features/payment/presentation/pages/order_success_page.dart
// Premium success screen shown after order is created
// ============================================================
import 'dart:math' as math;
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessPage extends StatefulWidget {
  final OrderEntity order;
  const OrderSuccessPage({super.key, required this.order});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  late final Animation<double> _circle = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
  );
  late final Animation<double> _check = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.4, 0.75, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _content = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _isCash => widget.order.payment.method == 'cashTransfer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated circle + check
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Column(
                  children: [
                    Transform.scale(
                      scale: _circle.value,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success.withOpacity(0.12),
                          border: Border.all(
                            color: AppColors.success,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Opacity(
                          opacity: _check.value,
                          child: const Icon(
                            Icons.check_rounded,
                            size: 56,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Opacity(
                      opacity: _content.value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - _content.value) * 24),
                        child: Column(
                          children: [
                            Text(
                              _isCash
                                  ? 'تم إرسال إثبات الدفع بنجاح'
                                  : 'تم الدفع بنجاح',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              _isCash
                                  ? 'تم استلام طلبك رقم #${widget.order.id.substring(0, 8).toUpperCase()}.\nسيتم مراجعة عملية التحويل خلال ساعة إلى ساعتين ثم تأكيد الطلب.'
                                  : 'تم تأكيد طلبك رقم #${widget.order.id.substring(0, 8).toUpperCase()}.\nوجارٍ الآن تجهيز الطلب للشحن.',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // Order summary chips
                            _OrderSummaryRow(order: widget.order),
                            const SizedBox(height: AppSpacing.xxl),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () => context.go(RoutePaths.orders),
                                child: const Text('عرض طلباتي'),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextButton(
                              onPressed: () => context.go(RoutePaths.home),
                              child: const Text('متابعة التسوق'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  final OrderEntity order;
  const _OrderSummaryRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Chip(
          Icons.receipt_outlined,
          order.items.length == 1
              ? 'منتج واحد'
              : '${order.items.length} منتجات',
        ),
        const SizedBox(width: 12),
        _Chip(
          Icons.attach_money,
          '${order.pricing.total.toStringAsFixed(2)}\ج.م',
        ),
        const SizedBox(width: 12),
        _Chip(
          Icons.payment_outlined,
          order.payment.method == 'cashTransfer'
              ? 'محفظة كاش'
              : order.payment.method == 'card'
              ? 'بطاقة بنكية'
              : 'محفظة إلكترونية',
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}
