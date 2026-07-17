// ============================================================
// features/payment/presentation/pages/payment_selection_page.dart
// TASK 1: Partial + Full payment choice with premium UI
// ============================================================
import 'dart:math' as math;
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:ecommerce_el7out/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/card_payment_page.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/cash_transefer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSelectionPage extends StatefulWidget {
  final PendingOrderDraft draft;
  const PaymentSelectionPage({super.key, required this.draft});

  @override
  State<PaymentSelectionPage> createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage>
    with SingleTickerProviderStateMixin {
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

  PendingOrderDraft get _activeDraft => PendingOrderDraft(
    userId: widget.draft.userId,
    userEmail: widget.draft.userEmail,
    cartItems: widget.draft.cartItems,
    shippingAddress: widget.draft.shippingAddress,
    subtotal: widget.draft.subtotal,
    shipping: widget.draft.shipping,
    total: widget.draft.total,
    paymentType: _paymentType,
  );

  @override
  Widget build(BuildContext context) {
    final total = widget.draft.total;
    final upfront = _paymentType == PaymentType.full ? total : total * 0.30;
    final onDeliv = _paymentType == PaymentType.full ? 0.0 : total * 0.70;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'PAYMENT',
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
              child: _AnimatedTotalCard(total: total, animCtrl: _pulseCtrl),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Step 1: Choose payment type ────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: _StepLabel(step: '01', label: 'CHOOSE PAYMENT PLAN'),
            ),
            const SizedBox(height: AppSpacing.md),
            _PaymentTypeSelector(
              selected: _paymentType,
              total: total,
              onChanged: (t) => setState(() => _paymentType = t),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Step 2: Payment summary ────────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 160),
              child: _StepLabel(step: '02', label: 'PAYMENT SUMMARY'),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 340),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(anim),
                  child: child,
                ),
              ),
              child: _PaymentSummaryCard(
                key: ValueKey(_paymentType),
                upfront: upfront,
                onDelivery: onDeliv,
                paymentType: _paymentType,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Step 3: Transfer numbers ───────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: _StepLabel(step: '03', label: 'TRANSFER TO'),
            ),
            const SizedBox(height: AppSpacing.md),
            FadeSlideIn(
              delay: const Duration(milliseconds: 280),
              child: _TransferNumbersCard(upfront: upfront),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── CTA ────────────────────────────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 320),
              child: _ContinueButton(
                draft: _activeDraft,
                paymentType: _paymentType,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SecurityRow(),
            const SizedBox(height: AppSpacing.xxl),
          ],
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
                      'ORDER TOTAL',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
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
                      'Choose your payment plan below',
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

// ── Payment type selector ─────────────────────────────────────
class _PaymentTypeSelector extends StatelessWidget {
  final PaymentType selected;
  final double total;
  final ValueChanged<PaymentType> onChanged;

  const _PaymentTypeSelector({
    required this.selected,
    required this.total,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeCard(
          type: PaymentType.partial,
          selected: selected == PaymentType.partial,
          title: 'Partial Payment',
          subtitle: 'Pay 30% now, 70% on delivery',
          badge: '30% NOW',
          badgeColor: AppColors.gold,
          icon: Icons.timelapse_outlined,
          iconColor: AppColors.gold,
          amount: total * 0.30,
          highlight: 'Popular',
          onTap: () => onChanged(PaymentType.partial),
        ),
        const SizedBox(height: 12),
        _TypeCard(
          type: PaymentType.full,
          selected: selected == PaymentType.full,
          title: 'Full Payment',
          subtitle: 'Pay 100% now — order confirmed instantly',
          badge: 'FULL PAY',
          badgeColor: AppColors.success,
          icon: Icons.verified_outlined,
          iconColor: AppColors.success,
          amount: total,
          highlight: 'Fastest',
          onTap: () => onChanged(PaymentType.full),
        ),
      ],
    );
  }
}

class _TypeCard extends StatefulWidget {
  final PaymentType type;
  final bool selected;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;
  final double amount;
  final String highlight;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
    required this.amount,
    required this.highlight,
    required this.onTap,
  });

  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 1.025,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

  @override
  void didUpdateWidget(_TypeCard old) {
    super.didUpdateWidget(old);
    widget.selected ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: widget.selected
                ? widget.iconColor.withOpacity(0.05)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.selected
                  ? widget.iconColor
                  : Theme.of(context).colorScheme.outline.withOpacity(0.45),
              width: widget.selected ? 2.0 : 0.8,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: widget.iconColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(
                    widget.selected ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: widget.badgeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.badge,
                            style: TextStyle(
                              color: widget.badgeColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '\$${widget.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: widget.iconColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.highlight,
                            style: TextStyle(
                              color: widget.iconColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Selector
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: widget.selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey(true),
                        color: widget.iconColor,
                        size: 24,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        key: const ValueKey(false),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.28),
                        size: 24,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Payment summary card ──────────────────────────────────────
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
                      'PAY NOW',
                      '\$${upfront.toStringAsFixed(2)}',
                      AppColors.gold,
                    ),
                    Container(width: 1, height: 48, color: Colors.white12),
                    _SplitCol(
                      'ON DELIVERY',
                      '\$${onDelivery.toStringAsFixed(2)}',
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
                        'Full amount paid now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${upfront.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Order confirmed immediately after verification',
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

// ── Transfer numbers card ─────────────────────────────────────
class _TransferNumbersCard extends StatelessWidget {
  final double upfront;
  const _TransferNumbersCard({required this.upfront});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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

  void _copy() {
    // Clipboard.setData(ClipboardData(text: widget.number));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
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
                '\$${widget.amount.toStringAsFixed(2)}',
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

// ── Continue button ───────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final PendingOrderDraft draft;
  final PaymentType paymentType;

  const _ContinueButton({required this.draft, required this.paymentType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          getIt<PaymentCubit>().setDraft(draft);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PaymentCubit>(),
                child: CashTransferPage(draft: draft),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              paymentType == PaymentType.full
                  ? 'UPLOAD FULL PAYMENT PROOF'
                  : 'UPLOAD 30% PAYMENT PROOF',
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
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SB(Icons.lock_outline, 'SSL'),
        const SizedBox(width: 20),
        _SB(Icons.verified_outlined, 'Verified'),
        const SizedBox(width: 20),
        _SB(Icons.shield_outlined, 'Secure'),
      ],
    );
  }
}

class _SB extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SB(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: AppColors.success),
      const SizedBox(width: 4),
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
      ),
    ],
  );
}
