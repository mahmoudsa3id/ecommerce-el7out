// ============================================================
// features/admin/presentation/pages/admin_order_detail_page.dart
// Full order detail for admin with payment proof viewer
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/order/data/model/order_model.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';

// ── Helper: Arabic labels ───────────────────────────────────
String _statusArabic(OrderStatus s) {
  switch (s) {
    case OrderStatus.pending:
      return 'قيد الانتظار';
    case OrderStatus.confirmed:
      return 'مؤكد';
    case OrderStatus.processing:
      return 'قيد التجهيز';
    case OrderStatus.shipped:
      return 'تم الشحن';
    case OrderStatus.delivered:
      return 'تم التوصيل';
    case OrderStatus.cancelled:
      return 'ملغي';
  }
}

String _paymentStatusArabic(PaymentStatus s) {
  switch (s) {
    case PaymentStatus.paid:
      return 'مدفوع';
    case PaymentStatus.partiallyPaid:
      return 'مدفوع جزئياً';
    case PaymentStatus.waitingVerification:
      return 'قيد المراجعة';
    case PaymentStatus.approved:
      return 'مقبول';
    case PaymentStatus.rejected:
      return 'مرفوض';
    case PaymentStatus.failed:
      return 'فشل';
    default:
      return 'قيد الانتظار';
  }
}

class AdminOrderDetailPage extends StatelessWidget {
  final String orderId;
  const AdminOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلب #${orderId.substring(0, 8).toUpperCase()}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getIt<FirebaseFirestore>()
            .collection(AppConstants.firestoreOrders)
            .doc(orderId)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = OrderModel.fromFirestore(
            snap.data!.data()!,
            snap.data!.id,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Status timeline ─────────────────────────
                FadeSlideIn(child: _StatusTimeline(order: order)),
                const SizedBox(height: AppSpacing.xl),

                // ── Quick status update ─────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 60),
                  child: _StatusActions(order: order),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Customer info ───────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: _Section(
                    title: 'العميل',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(Icons.person_outline, order.customer.fullName),
                        const SizedBox(height: 6),
                        _InfoRow(
                          Icons.phone_outlined,
                          order.customer.phoneNumber,
                        ),
                        const SizedBox(height: 6),
                        _InfoRow(Icons.mail_outline, order.customer.email),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        _InfoRow(
                          Icons.location_on_outlined,
                          order.shippingAddress.formatted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Payment info ────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 140),
                  child: _PaymentSection(payment: order.payment),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Order items ─────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 180),
                  child: _Section(
                    title: 'العناصر (${order.items.length})',
                    child: Column(
                      children: order.items
                          .map((item) => _OrderItemRow(item: item))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Pricing ─────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 220),
                  child: _PricingSection(pricing: order.pricing),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final OrderEntity order;
  const _StatusTimeline({required this.order});

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error),
            SizedBox(width: 10),
            Text(
              'تم إلغاء الطلب',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final currentIdx = _steps.indexOf(order.status);
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = (i ~/ 2) < currentIdx;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2,
              color: done ? AppColors.gold : Theme.of(context).dividerColor,
            ),
          );
        }
        final idx = i ~/ 2;
        final done = idx <= currentIdx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppColors.gold : Colors.transparent,
                border: Border.all(
                  color: done ? AppColors.gold : Theme.of(context).dividerColor,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              _statusArabic(_steps[idx]),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 8.5),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _StatusActions extends StatelessWidget {
  final OrderEntity order;
  const _StatusActions({required this.order});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'تحديث الحالة',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: OrderStatus.values.where((s) => s != order.status).map((s) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('تأكيد'),
                      content: Text('تغيير الحالة إلى ${_statusArabic(s)}؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('إلغاء'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('تأكيد'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await getIt<FirebaseFirestore>()
                        .collection(AppConstants.firestoreOrders)
                        .doc(order.id)
                        .update({
                          'status': s.name,
                          'updatedAt': FieldValue.serverTimestamp(),
                          'statusHistory': FieldValue.arrayUnion([
                            {'status': s.name, 'timestamp': Timestamp.now()},
                          ]),
                        });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    _statusArabic(s),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _PaymentSection extends StatelessWidget {
  final PaymentInfoEntity payment;
  const _PaymentSection({required this.payment});

  Color get _statusColor {
    switch (payment.status) {
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.partiallyPaid:
        return AppColors.gold;
      case PaymentStatus.waitingVerification:
        return Colors.orange;
      case PaymentStatus.failed:
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'الدفع',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payment.method.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _paymentStatusArabic(payment.status),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(
            Icons.paid_outlined,
            'مدفوع: ${payment.paidAmount.toStringAsFixed(2)} ج.م',
          ),
          if (payment.pendingAmount > 0) ...[
            const SizedBox(height: 6),
            _InfoRow(
              Icons.schedule_outlined,
              'متبقي: ${payment.pendingAmount.toStringAsFixed(2)} ج.م',
            ),
          ],
          if (payment.transactionId != null) ...[
            const SizedBox(height: 6),
            _InfoRow(
              Icons.tag_outlined,
              'رقم العملية: ${payment.transactionId}',
            ),
          ],
          // ── Proof image ──────────────────────────────────
          if (payment.proofImageUrl != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Text(
              'إثبات التحويل',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () =>
                  _showProofFullscreen(context, payment.proofImageUrl!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      payment.proofImageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black54,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'اضغط للعرض بالحجم الكامل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showProofFullscreen(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: Stack(
          children: [
            InteractiveViewer(child: Image.network(url, fit: BoxFit.contain)),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton.filledTonal(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.productImageUrl != null
                ? Image.network(
                    item.productImageUrl!,
                    width: 68,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 68,
                    height: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.checkroom_outlined, size: 28),
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
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _Chip2(item.selectedColor),
                    const SizedBox(width: 6),
                    _Chip2(item.selectedSize),
                    const SizedBox(width: 6),
                    _Chip2('×${item.quantity}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.unitPrice.toStringAsFixed(2)} ج.م للقطعة',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${item.totalPrice.toStringAsFixed(2)} ج.م',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

class _Chip2 extends StatelessWidget {
  final String label;
  const _Chip2(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
class _PricingSection extends StatelessWidget {
  final OrderPricingEntity pricing;
  const _PricingSection({required this.pricing});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'إجمالي الطلب',
      child: Column(
        children: [
          _PriceRow('المجموع الفرعي', pricing.subtotal),
          if (pricing.discount > 0) _PriceRow('الخصم', -pricing.discount),
          _PriceRow('الشحن', pricing.shipping),
          if (pricing.taxes > 0) _PriceRow('الضرائب', pricing.taxes),
          const Divider(height: 20),
          _PriceRow('الإجمالي', pricing.total, bold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _PriceRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${value.abs().toStringAsFixed(2)} ج.م',
            style: style?.copyWith(
              color: bold ? AppColors.gold : null,
              fontWeight: bold ? FontWeight.w700 : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

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
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.gold),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    ],
  );
}
