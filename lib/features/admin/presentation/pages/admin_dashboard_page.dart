// ============================================================
// features/admin/presentation/pages/admin_dashboard_page.dart
// COMPLETE REDESIGN – Professional analytics dashboard
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/core/widgets/shimmer_loader.dart';
import 'package:ecommerce_el7out/features/order/data/model/order_model.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Helper: Arabic status label ─────────────────────────────
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

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final hPad = isWeb
        ? ResponsiveLayout.horizontalPadding(context)
        : AppSpacing.pageHorizontal.toDouble();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isWeb
          ? null
          : AppBar(
              title: const Text('لوحة التحكم'),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getIt<FirebaseFirestore>()
            .collection(AppConstants.firestoreOrders)
            .orderBy('createdAt', descending: true)
            .limit(200)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          final orders = docs
              .map((d) => OrderModel.fromFirestore(d.data(), d.id))
              .toList();

          final stats = _DashStats.from(orders);

          return CustomScrollView(
            slivers: [
              if (isWeb)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 28),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'لوحة التحكم',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          children: [
                            _LiveDot(),
                            const SizedBox(width: 6),
                            Text(
                              'مباشر',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.success),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              // ── KPI Cards ─────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverToBoxAdapter(
                  child: isWeb
                      ? _KpiGridWeb(stats: stats)
                      : _KpiGridMobile(stats: stats),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              // ── Quick Actions ──────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverToBoxAdapter(child: _QuickActions()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              // ── Status breakdown ───────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverToBoxAdapter(
                  child: _StatusBreakdown(orders: orders),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              // ── Recent Orders ──────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أحدث الطلبات',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
                      ),
                      TextButton(
                        onPressed: () => context.push(RoutePaths.adminOrders),
                        child: const Text('عرض الكل'),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final o = orders.take(5).toList()[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: StaggeredListEntrance(
                        index: i,
                        child: _RecentOrderTile(order: o),
                      ),
                    );
                  }, childCount: orders.take(5).length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              // ── Top products ───────────────────────────────
              if (stats.topProducts.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: _TopProducts(products: stats.topProducts),
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Stats computation ─────────────────────────────────────────
class _DashStats {
  final double totalRevenue;
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;
  final double averageOrderValue;
  final Map<String, int> topProducts;
  final Map<OrderStatus, int> statusBreakdown;
  final double todayRevenue;
  final int todayOrders;

  const _DashStats({
    required this.totalRevenue,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    required this.averageOrderValue,
    required this.topProducts,
    required this.statusBreakdown,
    required this.todayRevenue,
    required this.todayOrders,
  });

  factory _DashStats.from(List<OrderModel> orders) {
    double revenue = 0;
    int pending = 0;
    int delivered = 0;
    final topP = <String, int>{};
    final statusB = <OrderStatus, int>{};
    double todayRev = 0;
    int todayOrd = 0;
    final today = DateTime.now();

    for (final o in orders) {
      revenue += o.pricing.total;
      statusB[o.status] = (statusB[o.status] ?? 0) + 1;

      if (o.status == OrderStatus.pending) pending++;
      if (o.status == OrderStatus.delivered) delivered++;

      final isToday =
          o.createdAt.year == today.year &&
          o.createdAt.month == today.month &&
          o.createdAt.day == today.day;
      if (isToday) {
        todayRev += o.pricing.total;
        todayOrd++;
      }

      for (final item in o.items) {
        topP[item.productName] = (topP[item.productName] ?? 0) + item.quantity;
      }
    }

    final sorted = topP.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _DashStats(
      totalRevenue: revenue,
      totalOrders: orders.length,
      pendingOrders: pending,
      deliveredOrders: delivered,
      averageOrderValue: orders.isEmpty ? 0 : revenue / orders.length,
      topProducts: Map.fromEntries(sorted.take(5)),
      statusBreakdown: statusB,
      todayRevenue: todayRev,
      todayOrders: todayOrd,
    );
  }
}

// ── KPI grids ─────────────────────────────────────────────────
class _KpiGridWeb extends StatelessWidget {
  final _DashStats stats;
  const _KpiGridWeb({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: _kpiCards(stats),
    );
  }
}

class _KpiGridMobile extends StatelessWidget {
  final _DashStats stats;
  const _KpiGridMobile({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = _kpiCards(stats);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 12),
            Expanded(child: cards[3]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: cards[4]),
            const SizedBox(width: 12),
            Expanded(child: cards[5]),
          ],
        ),
      ],
    );
  }
}

List<Widget> _kpiCards(_DashStats s) => [
  _KpiCard(
    label: 'إجمالي الإيرادات',
    value: '${s.totalRevenue.toStringAsFixed(0)} ج.م',
    icon: Icons.attach_money_rounded,
    color: AppColors.gold,
    sub: 'كل الوقت',
  ),
  _KpiCard(
    label: 'إيرادات اليوم',
    value: '${s.todayRevenue.toStringAsFixed(0)} ج.م',
    icon: Icons.today_outlined,
    color: AppColors.success,
    sub: '${s.todayOrders} طلب اليوم',
  ),
  _KpiCard(
    label: 'إجمالي الطلبات',
    value: '${s.totalOrders}',
    icon: Icons.receipt_long_outlined,
    color: AppColors.info,
    sub: 'كل الوقت',
  ),
  _KpiCard(
    label: 'قيد الانتظار',
    value: '${s.pendingOrders}',
    icon: Icons.pending_outlined,
    color: Colors.orange,
    sub: 'يحتاج متابعة',
  ),
  _KpiCard(
    label: 'تم التوصيل',
    value: '${s.deliveredOrders}',
    icon: Icons.check_circle_outline,
    color: AppColors.success,
    sub: 'مكتمل',
  ),
  _KpiCard(
    label: 'متوسط الطلب',
    value: '${s.averageOrderValue.toStringAsFixed(0)} ج.م',
    icon: Icons.bar_chart_outlined,
    color: const Color(0xFF7C3AED),
    sub: 'لكل طلب',
  ),
];

// ─────────────────────────────────────────────────────────────
class _KpiCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.sub,
  });

  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.color.withOpacity(0.06)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? widget.color.withOpacity(0.5)
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: _hovered ? 1.5 : 0.8,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 20),
                ),
                Text(
                  widget.sub,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontSize: 9.5),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Actions ──────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ActionChip(
                icon: Icons.receipt_long_outlined,
                label: 'كل الطلبات',
                color: AppColors.info,
                onTap: () => context.push(RoutePaths.adminOrders),
              ),
              const SizedBox(width: 10),
              _ActionChip(
                icon: Icons.shopping_bag_outlined,
                label: 'المنتجات',
                color: AppColors.gold,
                onTap: () => context.push(RoutePaths.adminProducts),
              ),
              const SizedBox(width: 10),
              _ActionChip(
                icon: Icons.category_outlined,
                label: 'الأقسام',
                color: const Color(0xFF7C3AED),
                onTap: () => context.push(RoutePaths.adminCategories),
              ),
              const SizedBox(width: 10),
              _ActionChip(
                icon: Icons.notifications_outlined,
                label: 'الإشعارات',
                color: AppColors.success,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.12)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? widget.color
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: _hovered ? 1.4 : 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.color, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Status Breakdown ──────────────────────────────────────────
class _StatusBreakdown extends StatelessWidget {
  final List<OrderModel> orders;
  const _StatusBreakdown({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox();

    final counts = <OrderStatus, int>{};
    for (final o in orders) {
      counts[o.status] = (counts[o.status] ?? 0) + 1;
    }
    final total = orders.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'حالة الطلبات',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            children: OrderStatus.values.map((status) {
              final count = counts[status] ?? 0;
              final pct = total == 0 ? 0.0 : count / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _StatusBar(status: status, count: count, pct: pct),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final OrderStatus status;
  final int count;
  final double pct;

  const _StatusBar({
    required this.status,
    required this.count,
    required this.pct,
  });

  Color get _color {
    switch (status) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.shipped:
        return AppColors.info;
      case OrderStatus.processing:
        return const Color(0xFF7C3AED);
      case OrderStatus.confirmed:
        return AppColors.gold;
      case OrderStatus.pending:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            _statusArabic(status),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 9.5),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation(_color),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ── Recent Order Tile ─────────────────────────────────────────
class _RecentOrderTile extends StatelessWidget {
  final OrderEntity order;
  const _RecentOrderTile({required this.order});

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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            // Payment status indicator
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: _statusColor(order.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${order.id.substring(0, 8).toUpperCase()}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 13),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _statusArabic(order.status),
                          style: TextStyle(
                            color: _statusColor(order.status),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.customer.fullName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      Text(
                        '${order.items.length} عنصر',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text('·', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 8),
                      Text(
                        '${order.pricing.total.toStringAsFixed(2)} ج.م',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Top Products ──────────────────────────────────────────────
class _TopProducts extends StatelessWidget {
  final Map<String, int> products;
  const _TopProducts({required this.products});

  @override
  Widget build(BuildContext context) {
    final max = products.values.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأكثر مبيعاً',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            children: products.entries.map((e) {
              final rank = products.keys.toList().indexOf(e.key) + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Text(
                      '#$rank',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.gold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: e.value / max),
                            duration: Duration(milliseconds: 600 + rank * 100),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, __) => LinearProgressIndicator(
                              value: v,
                              minHeight: 4,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.gold,
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'تم بيع ${e.value}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Live dot ──────────────────────────────────────────────────
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
  Widget build(BuildContext context) {
    return FadeTransition(
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
}
