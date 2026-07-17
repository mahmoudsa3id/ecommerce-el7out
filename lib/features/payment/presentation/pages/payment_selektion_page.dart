// ============================================================
// features/payment/presentation/pages/payment_selection_page.dart
// MERGED: All payment gateways (Cash/InstaPay, PayMob Wallet, Card)
// + Partial/Full payment plan choice for the Cash/InstaPay gateway.
// ============================================================
import 'dart:math' as math;
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/payment_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:ecommerce_el7out/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/card_payment_page.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/cash_transefer_page.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/pay_mob_wallet_page.dart';
import 'package:ecommerce_el7out/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSelectionPage extends StatefulWidget {
  /// Comes from CheckoutPage with a PendingOrderDraft
  /// (order is created only after payment succeeds).
  final PendingOrderDraft draft;

  const PaymentSelectionPage({super.key, required this.draft});

  @override
  State<PaymentSelectionPage> createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage>
    with SingleTickerProviderStateMixin {
  double get _total => widget.draft.total;

  /// Which payment gateway is selected.
  PaymentMethodType? _selectedMethod;

  /// Only meaningful when [_selectedMethod] == cashTransfer: partial (30%) or full.
  PaymentType _paymentType = PaymentType.partial;

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  /// Builds the draft that will actually be passed forward, with the
  /// chosen payment type baked in (only relevant for the cash gateway —
  /// PayMob wallet & card are always "full pay").
  PendingOrderDraft get _activeDraft {
    final effectiveType = _selectedMethod == PaymentMethodType.cashTransfer
        ? _paymentType
        : PaymentType.full;
    return PendingOrderDraft(
      userId: widget.draft.userId,
      userEmail: widget.draft.userEmail,
      cartItems: widget.draft.cartItems,
      shippingAddress: widget.draft.shippingAddress,
      subtotal: widget.draft.subtotal,
      shipping: widget.draft.shipping,
      total: widget.draft.total,
      paymentType: effectiveType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: getIt<PaymentCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.payment,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Premium total card ─────────────────────────
              FadeSlideIn(
                child: _AnimatedTotalCard(total: _total, animCtrl: _pulseCtrl),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Step 1: choose payment gateway ─────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: _StepLabel(step: '1', label: 'اختر طريقة الدفع'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Gateway 1: Cash / InstaPay Transfer (supports partial/full)
              StaggeredEntrance(
                index: 0,
                child: _PaymentMethodCard(
                  icon: Icons.account_balance_outlined,
                  iconColor: AppColors.gold,
                  title: 'انستا باي / دفع بمحفظة كاش',
                  subtitle:
                      'ادفع جزء الان او كامل المبلغ عبر انستا باي او محفظة كاش وارسل اسكرين بالدفع.',
                  badge: 'دفع جزئي / كامل',
                  badgeColor: AppColors.gold,
                  selected: _selectedMethod == PaymentMethodType.cashTransfer,
                  onTap: () => setState(
                    () => _selectedMethod = PaymentMethodType.cashTransfer,
                  ),
                  child: _selectedMethod == PaymentMethodType.cashTransfer
                      ? _CashGatewayDetails(
                          total: _total,
                          paymentType: _paymentType,
                          onPaymentTypeChanged: (t) =>
                              setState(() => _paymentType = t),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Gateway 2: Mobile Wallet via PayMob (full pay only)
              StaggeredEntrance(
                index: 1,
                child: _PaymentMethodCard(
                  icon: Icons.phone_android_outlined,
                  iconColor: AppColors.info,
                  title: 'محفظة الهاتف المحمول عبر PayMob',
                  subtitle: 'ادفع عبر فودافون كاش او انستا باي عبر PayMob.',
                  badge: 'دفع كامل',
                  badgeColor: AppColors.success,
                  selected: _selectedMethod == PaymentMethodType.paymobWallet,
                  onTap: () => setState(
                    () => _selectedMethod = PaymentMethodType.paymobWallet,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Gateway 3: Visa / Mastercard / Meeza (full pay only)
              StaggeredEntrance(
                index: 2,
                child: _PaymentMethodCard(
                  icon: Icons.credit_card_outlined,
                  iconColor: const Color(0xFF1A1F71),
                  title: 'Credit / Debit Card',
                  subtitle: 'دفع فيزا امن, ماستر كارد, او ميزا عبر PayMob.',
                  badge: 'دفع كامل',
                  badgeColor: AppColors.success,
                  selected: _selectedMethod == PaymentMethodType.card,
                  onTap: () =>
                      setState(() => _selectedMethod = PaymentMethodType.card),
                  child: _selectedMethod == PaymentMethodType.card
                      ? const _CardLogos()
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              if (_selectedMethod != null)
                FadeSlideIn(
                  key: ValueKey(_selectedMethod),
                  child: _ContinueButton(
                    selected: _selectedMethod!,
                    paymentType: _paymentType,
                    draft: _activeDraft,
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),

              // Security badges
              FadeSlideIn(
                delay: const Duration(milliseconds: 300),
                child: const _SecurityBadges(),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Animated total card with gold pulse ───────────────────────
class _AnimatedTotalCard extends StatelessWidget {
  final double total;
  final AnimationController animCtrl;
  const _AnimatedTotalCard({required this.total, required this.animCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animCtrl,
      builder: (_, __) {
        final glow = 0.08 + 0.06 * math.sin(animCtrl.value * math.pi * 2);
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B0B0A), Color(0xFF1C1A15)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(glow),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اجمالي الاوردر',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${total.toStringAsFixed(2)}\ج.م',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اختر بوابة الدفع المناسبة لك',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.goldLight, AppColors.gold],
                  stops: [
                    animCtrl.value.clamp(0.0, 1.0),
                    (animCtrl.value + 0.5).clamp(0.0, 1.0),
                  ],
                ).createShader(bounds),
                child: const Icon(
                  Icons.diamond_outlined,
                  size: 52,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Step label ────────────────────────────────────────────────
class _StepLabel extends StatelessWidget {
  final String step;
  final String label;
  const _StepLabel({required this.step, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.8),
        ),
      ],
    );
  }
}

// ── Generic payment gateway card (top-level selector) ─────────
class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;

  const _PaymentMethodCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.selected,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? iconColor.withOpacity(0.04)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? iconColor
                : Theme.of(context).colorScheme.outline.withOpacity(0.6),
            width: selected ? 1.8 : 0.8,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: iconColor.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(selected ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: selected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey(true),
                          color: iconColor,
                          size: 22,
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          key: const ValueKey(false),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          size: 22,
                        ),
                ),
              ],
            ),
            // Expandable child content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: child != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: child!,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Expanded details for the Cash / InstaPay gateway ───────────
// Includes the partial (30%) / full payment-plan sub-selector,
// live summary, and transfer numbers.
class _CashGatewayDetails extends StatelessWidget {
  final double total;
  final PaymentType paymentType;
  final ValueChanged<PaymentType> onPaymentTypeChanged;

  const _CashGatewayDetails({
    required this.total,
    required this.paymentType,
    required this.onPaymentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final upfront = paymentType == PaymentType.full ? total : total * 0.30;
    final onDeliv = paymentType == PaymentType.full ? 0.0 : total * 0.70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خطة الدفع',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _PlanChip(
                label: 'جزئي 30%',
                selected: paymentType == PaymentType.partial,
                color: AppColors.gold,
                onTap: () => onPaymentTypeChanged(PaymentType.partial),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PlanChip(
                label: 'دفع كامل',
                selected: paymentType == PaymentType.full,
                color: AppColors.success,
                onTap: () => onPaymentTypeChanged(PaymentType.full),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween(begin: 0.96, end: 1.0).animate(anim),
              child: child,
            ),
          ),
          child: _PaymentSummaryCard(
            key: ValueKey(paymentType),
            upfront: upfront,
            onDelivery: onDeliv,
            paymentType: paymentType,
          ),
        ),
        const SizedBox(height: 14),
        _TransferNumbersCard(upfront: upfront),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 13, color: Colors.orange),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'بعد التحويل, عليك بارسال صورة التحويل.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.orange),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _PlanChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? color
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: selected ? 1.6 : 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ── Payment summary card (30/70 split vs full) ─────────────────
class _PaymentSummaryCard extends StatelessWidget {
  final double upfront;
  final double onDelivery;
  final PaymentType paymentType;

  const _PaymentSummaryCard({
    super.key,
    required this.upfront,
    required this.onDelivery,
    required this.paymentType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0B0B0A),
            paymentType == PaymentType.full
                ? const Color(0xFF0A1A0A)
                : const Color(0xFF1A1200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: paymentType == PaymentType.partial
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SplitCol(
                      'ادفع الان',
                      '${upfront.toStringAsFixed(2)}\ج.م',
                      AppColors.gold,
                    ),
                    Container(width: 1, height: 48, color: Colors.white12),
                    _SplitCol(
                      'عند الاستلام',
                      '${onDelivery.toStringAsFixed(2)}\ج.م',
                      Colors.white60,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 0.30),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 6,
                      valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '30%',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '100%',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 44,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'دفع المبلغ بالكامل الان',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${upfront.toStringAsFixed(2)}\ج.م',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'يتم تأكيد الاوردر فور التحقق من الدفع',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SplitCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SplitCol(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

// ── Transfer numbers card (InstaPay + Vodafone Cash) ───────────
class _TransferNumbersCard extends StatelessWidget {
  final double upfront;
  const _TransferNumbersCard({required this.upfront});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.45),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          _NumberTile(
            icon: Icons.flash_on_rounded,
            service: 'InstaPay',
            number: AppConstants.instapayNumber,
            color: AppColors.gold,
            amount: upfront,
          ),
          const SizedBox(height: 10),
          _NumberTile(
            icon: Icons.phone_android_outlined,
            service: 'Vodafone Cash',
            number: AppConstants.cashNumber,
            color: const Color(0xFFE60000),
            amount: upfront,
          ),
        ],
      ),
    );
  }
}

class _NumberTile extends StatefulWidget {
  final IconData icon;
  final String service;
  final String number;
  final Color color;
  final double amount;
  const _NumberTile({
    required this.icon,
    required this.service,
    required this.number,
    required this.color,
    required this.amount,
  });

  @override
  State<_NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<_NumberTile> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.number));

    setState(() => _copied = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الرقم'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, color: widget.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  widget.number,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: _copy,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _copied
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.success,
                          size: 20,
                          key: ValueKey('check'),
                        )
                      : Icon(
                          Icons.copy_outlined,
                          color: widget.color,
                          size: 20,
                          key: const ValueKey('copy'),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.amount.toStringAsFixed(2)}/ج.م',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Card logos (Visa / Mastercard / Meeza) ─────────────────────
class _CardLogos extends StatelessWidget {
  const _CardLogos();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CardLogo('VISA', const Color(0xFF1A1F71), Colors.white),
        const SizedBox(width: 8),
        _CardLogo('MC', Colors.red, Colors.white),
        const SizedBox(width: 8),
        _CardLogo('MEEZA', const Color(0xFF006C35), Colors.white),
      ],
    );
  }
}

class _CardLogo extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _CardLogo(this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ── Continue button — routes to the right gateway page ─────────
class _ContinueButton extends StatelessWidget {
  final PaymentMethodType selected;
  final PaymentType paymentType;
  final PendingOrderDraft draft;

  const _ContinueButton({
    required this.selected,
    required this.paymentType,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _navigate(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }

  String get _label {
    switch (selected) {
      case PaymentMethodType.cashTransfer:
        return paymentType == PaymentType.full
            ? 'حمل صورة الدفع الكامل'
            : 'حمل صورة تحويل الـ 30%';
      case PaymentMethodType.paymobWallet:
        return 'دفع بالمحفظة';
      case PaymentMethodType.card:
        return 'دفع بالكارد';
    }
  }

  void _navigate(BuildContext context) {
    // Keep the cubit's draft in sync for gateways that read it downstream.
    getIt<PaymentCubit>().setDraft(draft);

    switch (selected) {
      case PaymentMethodType.cashTransfer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentCubit>(),
              child: CashTransferPage(draft: draft),
            ),
          ),
        );
        break;
      case PaymentMethodType.paymobWallet:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentCubit>(),
              child: PayMobWalletPage(
                orderId: draft.userId,
                totalAmount: draft.total,
                billingAddress: draft.shippingAddress,
              ),
            ),
          ),
        );
        break;
      case PaymentMethodType.card:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentCubit>(),
              child: CardPaymentPage(
                orderId: draft.userId,
                totalAmount: draft.total,
                billingAddress: draft.shippingAddress,
              ),
            ),
          ),
        );
        break;
    }
  }
}

// ── Security badges ─────────────────────────────────────────────
class _SecurityBadges extends StatelessWidget {
  const _SecurityBadges();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Badge(Icons.lock_outline, 'SSL حماية'),
        const SizedBox(width: 20),
        _Badge(Icons.verified_outlined, 'PCI Compliant'),
        const SizedBox(width: 20),
        _Badge(Icons.shield_outlined, 'حماية بيانات'),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.success),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
