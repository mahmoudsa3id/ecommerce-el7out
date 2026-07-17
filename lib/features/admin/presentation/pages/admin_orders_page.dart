// ============================================================
// TASK 2 – features/admin/presentation/pages/admin_orders_page.dart
// Full payment type support + filters + screenshot viewer
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/shimmer_loader.dart';
import 'package:ecommerce_el7out/features/order/data/model/order_model.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _AdminFilter {
  all,
  pendingVerification,
  partial,
  full,
  approved,
  rejected,
}

extension _AdminFilterLabel on _AdminFilter {
  String get label {
    switch (this) {
      case _AdminFilter.all:
        return 'الكل';
      case _AdminFilter.pendingVerification:
        return 'قيد المراجعة';
      case _AdminFilter.partial:
        return 'جزئي';
      case _AdminFilter.full:
        return 'كامل';
      case _AdminFilter.approved:
        return 'مقبول';
      case _AdminFilter.rejected:
        return 'مرفوض';
    }
  }

  Color get color {
    switch (this) {
      case _AdminFilter.all:
        return Colors.grey;
      case _AdminFilter.pendingVerification:
        return Colors.orange;
      case _AdminFilter.partial:
        return AppColors.gold;
      case _AdminFilter.full:
        return AppColors.success;
      case _AdminFilter.approved:
        return AppColors.success;
      case _AdminFilter.rejected:
        return AppColors.error;
    }
  }
}

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});
  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  _AdminFilter _filter = _AdminFilter.all;

  bool _matchesFilter(OrderModel o) {
    switch (_filter) {
      case _AdminFilter.all:
        return true;
      case _AdminFilter.pendingVerification:
        return o.payment.status == PaymentStatus.waitingVerification;
      case _AdminFilter.partial:
        return o.payment.paymentType == PaymentType.partial;
      case _AdminFilter.full:
        return o.payment.paymentType == PaymentType.full;
      case _AdminFilter.approved:
        return o.payment.status == PaymentStatus.approved;
      case _AdminFilter.rejected:
        return o.payment.status == PaymentStatus.rejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الطلبات',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                _LiveDot(),
                const SizedBox(width: 6),
                Text(
                  'مباشر',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter chips ──────────────────────────────────
          _FilterBar(
            current: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          // ── Orders stream ──────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getIt<FirebaseFirestore>()
                  .collection(AppConstants.firestoreOrders)
                  .orderBy('createdAt', descending: true)
                  .limit(200)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return _LoadingSkeleton();
                }
                if (snap.hasError) {
                  return Center(child: Text('خطأ: ${snap.error}'));
                }
                final all = (snap.data?.docs ?? [])
                    .map((d) => OrderModel.fromFirestore(d.data(), d.id))
                    .toList();
                final orders = all.where(_matchesFilter).toList();

                if (orders.isEmpty) {
                  return Center(
                    child: FadeSlideIn(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 56),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'لا توجد طلبات لـ "${_filter.label}"',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (ctx, i) => StaggeredListEntrance(
                    index: i,
                    child: _AdminOrderCard(
                      order: orders[i],
                      onStatusChange: (s) => _updateStatus(orders[i].id, s),
                      onPaymentAction: (s) =>
                          _updatePaymentStatus(orders[i].id, s),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(String id, String status) async {
    await getIt<FirebaseFirestore>()
        .collection(AppConstants.firestoreOrders)
        .doc(id)
        .update({
          'status': status,
          'updatedAt': FieldValue.serverTimestamp(),
          'statusHistory': FieldValue.arrayUnion([
            {'status': status, 'timestamp': Timestamp.now()},
          ]),
        });
  }

  Future<void> _updatePaymentStatus(String id, String paymentStatus) async {
    await getIt<FirebaseFirestore>()
        .collection(AppConstants.firestoreOrders)
        .doc(id)
        .update({
          'payment.status': paymentStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }
}

// ── Helper: Arabic order status label ───────────────────────
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

// ── Filter bar ────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final _AdminFilter current;
  final ValueChanged<_AdminFilter> onChanged;
  const _FilterBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: _AdminFilter.values.map((f) {
          final sel = f == current;
          return GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? f.color.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel
                      ? f.color
                      : Theme.of(context).colorScheme.outline.withOpacity(0.45),
                  width: sel ? 1.5 : 0.8,
                ),
              ),
              child: Text(
                f.label,
                style: TextStyle(
                  color: sel
                      ? f.color
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Order card ────────────────────────────────────────────────
class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final ValueChanged<String> onStatusChange;
  final ValueChanged<String> onPaymentAction;

  const _AdminOrderCard({
    required this.order,
    required this.onStatusChange,
    required this.onPaymentAction,
  });

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.shipped:
        return AppColors.info;
      default:
        return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.adminOrderDetail(order.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${order.id.substring(0, 8).toUpperCase()}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.customer.fullName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        order.customer.phoneNumber,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(
                      _statusArabic(order.status),
                      _statusColor(order.status),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.pricing.total.toStringAsFixed(2)} ج.م',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: AppColors.gold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Payment info row ─────────────────────────────
            _PaymentInfoRow(payment: order.payment),
            const SizedBox(height: 10),

            // ── Screenshot preview (if uploaded) ────────────
            if (order.payment.proofImageUrl != null)
              _ScreenshotPreview(
                url: order.payment.proofImageUrl!,
                onApprove: () => _confirmPaymentAction(context, 'approved'),
                onReject: () => _confirmPaymentAction(context, 'rejected'),
                canAct:
                    order.payment.status == PaymentStatus.waitingVerification,
              ),

            const Divider(height: 20),

            // ── Status actions ───────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ActionBtn(
                    'تأكيد',
                    'confirmed',
                    AppColors.gold,
                    order.status == OrderStatus.pending,
                    onStatusChange,
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    'قيد التجهيز',
                    'processing',
                    AppColors.info,
                    order.status == OrderStatus.confirmed,
                    onStatusChange,
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    'شحن',
                    'shipped',
                    AppColors.info,
                    order.status == OrderStatus.processing,
                    onStatusChange,
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    'توصيل',
                    'delivered',
                    AppColors.success,
                    order.status == OrderStatus.shipped,
                    onStatusChange,
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    'إلغاء',
                    'cancelled',
                    AppColors.error,
                    order.status != OrderStatus.delivered &&
                        order.status != OrderStatus.cancelled,
                    onStatusChange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPaymentAction(BuildContext context, String action) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${action == 'approved' ? 'قبول' : 'رفض'} الدفع؟'),
        content: Text(
          action == 'approved'
              ? 'سيتم اعتماد الدفع وتأكيد الطلب.'
              : 'سيتم رفض الدفع وإخطار العميل.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: action == 'rejected'
                ? ElevatedButton.styleFrom(backgroundColor: AppColors.error)
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(action == 'approved' ? 'قبول' : 'رفض'),
          ),
        ],
      ),
    );
    if (confirmed == true) onPaymentAction(action);
  }
}

// ── Payment info row ──────────────────────────────────────────
class _PaymentInfoRow extends StatelessWidget {
  final PaymentInfoEntity payment;
  const _PaymentInfoRow({required this.payment});

  Color get _typeColor =>
      payment.isPartial ? AppColors.gold : AppColors.success;
  Color get _statusColor {
    switch (payment.status) {
      case PaymentStatus.approved:
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.rejected:
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.waitingVerification:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusBadge(payment.paymentTypeLabel, _typeColor),
        const SizedBox(width: 8),
        _StatusBadge(payment.statusLabel, _statusColor),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'مدفوع: ${payment.paidAmount.toStringAsFixed(2)} ج.م',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (payment.pendingAmount > 0)
              Text(
                'متبقي: ${payment.pendingAmount.toStringAsFixed(2)} ج.م',
                style: Theme.of(context).textTheme.labelSmall,
              ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withOpacity(0.35)),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
    ),
  );
}

// ── Screenshot preview with approve/reject ────────────────────
class _ScreenshotPreview extends StatelessWidget {
  final String url;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool canAct;
  const _ScreenshotPreview({
    required this.url,
    required this.onApprove,
    required this.onReject,
    required this.canAct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إثبات الدفع',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showFullscreen(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Image.network(
                  url,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined, size: 40),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.zoom_out_map, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'اضغط للعرض بالحجم الكامل',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canAct) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.4),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'قبول',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.4),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: AppColors.error,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'رفض',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }

  void _showFullscreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 6,
              child: Center(child: Image.network(url)),
            ),
            Positioned(
              top: 44,
              right: 16,
              child: IconButton.filledTonal(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (canAct)
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onApprove();
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('قبول'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onReject();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('رفض'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                      ),
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

class _ActionBtn extends StatelessWidget {
  final String label;
  final String status;
  final Color color;
  final bool enabled;
  final ValueChanged<String> onTap;
  const _ActionBtn(
    this.label,
    this.status,
    this.color,
    this.enabled,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: enabled ? 1.0 : 0.35,
    duration: const Duration(milliseconds: 200),
    child: GestureDetector(
      onTap: enabled ? () => onTap(status) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
    itemCount: 5,
    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
    itemBuilder: (_, __) => const ShimmerLoader(height: 120),
  );
}

class _LiveDot extends StatefulWidget {
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
    child: Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
    ),
  );
}
