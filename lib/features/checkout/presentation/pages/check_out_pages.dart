// ============================================================
// features/checkout/presentation/pages/checkout_page.dart
// FIXED FLOW: Checkout only collects address, routes to payment
// Order is NOT created here
// ============================================================
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/extensions/app_context_extensions.dart';
import 'package:ecommerce_el7out/core/router/route_paths.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/app_button.dart';
import 'package:ecommerce_el7out/core/widgets/app_text_field.dart';
import 'package:ecommerce_el7out/core/widgets/responsive_layout.dart';
import 'package:ecommerce_el7out/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_el7out/features/auth/presentation/cubit/auth_state.dart';
import 'package:ecommerce_el7out/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:ecommerce_el7out/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/payment_selektion_page.dart';
import 'package:ecommerce_el7out/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addr1Ctrl = TextEditingController();
  final _addr2Ctrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Egypt');
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _addr1Ctrl,
      _addr2Ctrl,
      _cityCtrl,
      _stateCtrl,
      _countryCtrl,
      _phoneCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  AddressEntity get _address => AddressEntity(
    fullName: _nameCtrl.text.trim(),
    addressLine1: _addr1Ctrl.text.trim(),
    addressLine2: _addr2Ctrl.text.trim().isEmpty
        ? null
        : _addr2Ctrl.text.trim(),
    city: _cityCtrl.text.trim(),
    state: _stateCtrl.text.trim(),
    country: _countryCtrl.text.trim(),
    phoneNumber: _phoneCtrl.text.trim(),
  );

  /// FIXED: No order is created here.
  /// We build a PendingOrderDraft and pass it to PaymentSelectionPage.
  void _continueToPayment(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = getIt<AuthCubit>().state;

    final bool isGuest = auth is! AuthAuthenticated;

    final String customerId = isGuest ? 'guest' : auth.user.id;

    final String customerEmail = isGuest ? '' : auth.user.email;

    final cartState = context.read<CartCubit>().state;
    final cartItems = cartState.maybeWhen(
      loaded: (items) => items,
      orElse: () => <CartItemEntity>[],
    );

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حقيبتك فارغة')));
      return;
    }

    final subtotal = cartState.total;
    final shipping = subtotal >= 150 ? 0.0 : 9.99;

    final draft = PendingOrderDraft(
      userId: customerId,
      userEmail: customerEmail,
      cartItems: cartItems,
      shippingAddress: _address,
      subtotal: subtotal,
      shipping: shipping,
      total: subtotal + shipping,
    );

    // Store draft in PaymentCubit (in memory, no Firestore write yet)
    getIt<PaymentCubit>().setDraft(draft);

    // Navigate to payment selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<PaymentCubit>(),
          child: PaymentSelectionPage(draft: draft),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isWeb = ResponsiveLayout.isWeb(context);
    final hPad = isWeb
        ? ResponsiveLayout.horizontalPadding(context)
        : AppSpacing.pageHorizontal.toDouble();

    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.checkout,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(letterSpacing: 3),
          ),
        ),
        body: Form(
          key: _formKey,
          child: isWeb
              ? _WebCheckoutLayout(
                  nameCtrl: _nameCtrl,
                  addr1Ctrl: _addr1Ctrl,
                  addr2Ctrl: _addr2Ctrl,
                  cityCtrl: _cityCtrl,
                  stateCtrl: _stateCtrl,

                  countryCtrl: _countryCtrl,
                  phoneCtrl: _phoneCtrl,
                  hPad: hPad,
                  onConfirm: () => _continueToPayment(context),
                )
              : _MobileCheckoutLayout(
                  nameCtrl: _nameCtrl,
                  addr1Ctrl: _addr1Ctrl,
                  addr2Ctrl: _addr2Ctrl,
                  cityCtrl: _cityCtrl,
                  stateCtrl: _stateCtrl,
                  countryCtrl: _countryCtrl,
                  phoneCtrl: _phoneCtrl,
                  onConfirm: () => _continueToPayment(context),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _MobileCheckoutLayout extends StatelessWidget {
  final TextEditingController nameCtrl,
      addr1Ctrl,
      addr2Ctrl,
      cityCtrl,
      stateCtrl,
      countryCtrl,
      phoneCtrl;
  final VoidCallback onConfirm;

  const _MobileCheckoutLayout({
    required this.nameCtrl,
    required this.addr1Ctrl,
    required this.addr2Ctrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.countryCtrl,
    required this.phoneCtrl,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _AddressForm(
                nameCtrl: nameCtrl,
                addr1Ctrl: addr1Ctrl,
                addr2Ctrl: addr2Ctrl,
                cityCtrl: cityCtrl,
                stateCtrl: stateCtrl,
                countryCtrl: countryCtrl,
                phoneCtrl: phoneCtrl,
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<CartCubit, CartState>(
                builder: (ctx, state) {
                  final sub = state.total;
                  final ship = sub >= 150 ? 0.0 : 9.99;
                  return _OrderSummaryCard(subtotal: sub, shipping: ship);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'اكمل الدفع',
                icon: Icons.arrow_forward,
                onPressed: onConfirm,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _WebCheckoutLayout extends StatelessWidget {
  final TextEditingController nameCtrl,
      addr1Ctrl,
      addr2Ctrl,
      cityCtrl,
      stateCtrl,
      countryCtrl,
      phoneCtrl;
  final double hPad;
  final VoidCallback onConfirm;

  const _WebCheckoutLayout({
    required this.nameCtrl,
    required this.addr1Ctrl,
    required this.addr2Ctrl,
    required this.cityCtrl,
    required this.stateCtrl,

    required this.countryCtrl,
    required this.phoneCtrl,
    required this.hPad,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
            child: _AddressForm(
              nameCtrl: nameCtrl,
              addr1Ctrl: addr1Ctrl,
              addr2Ctrl: addr2Ctrl,
              cityCtrl: cityCtrl,
              stateCtrl: stateCtrl,
              countryCtrl: countryCtrl,
              phoneCtrl: phoneCtrl,
            ),
          ),
        ),
        SizedBox(
          width: 360,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 24, hPad, 24),
            child: BlocBuilder<CartCubit, CartState>(
              builder: (ctx, state) {
                final sub = state.total;
                final ship = sub >= 150 ? 0.0 : 9.99;
                return Column(
                  children: [
                    _OrderSummaryCard(subtotal: sub, shipping: ship),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'أكمل الدفع',
                      icon: Icons.arrow_forward,
                      onPressed: onConfirm,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _AddressForm extends StatelessWidget {
  final TextEditingController nameCtrl,
      addr1Ctrl,
      addr2Ctrl,
      cityCtrl,
      stateCtrl,
      countryCtrl,
      phoneCtrl;

  const _AddressForm({
    required this.nameCtrl,
    required this.addr1Ctrl,
    required this.addr2Ctrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.countryCtrl,
    required this.phoneCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlideIn(
          child: Text(
            l10n.shippingInfo,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.8),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.fullName,
          controller: nameCtrl,
          prefixIcon: Icons.person_outline,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l10n.required : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: l10n.phoneNumber,
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          validator: (v) =>
              (v == null || v.length < 8) ? l10n.phoneNumberError : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: l10n.addressLine1,
          controller: addr1Ctrl,
          prefixIcon: Icons.location_on_outlined,
          validator: (v) => (v == null || v.isEmpty) ? l10n.required : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(label: l10n.addressLine2, controller: addr2Ctrl),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: l10n.city,
                controller: cityCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.required : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppTextField(
                label: l10n.state,
                controller: stateCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.required : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        AppTextField(label: l10n.country, controller: countryCtrl),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  const _OrderSummaryCard({required this.subtotal, required this.shipping});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = subtotal + shipping;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderSummary,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          _SummaryRow(l10n.subtotal, '${subtotal.toStringAsFixed(2)}\ج.م'),
          const SizedBox(height: 8),
          _SummaryRow(
            l10n.shipping,
            shipping == 0 ? l10n.free : '${shipping.toStringAsFixed(2)}\ج.م ',
          ),
          if (subtotal < 150) ...[
            const SizedBox(height: 10),
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
              'أضف ${(150 - subtotal).toStringAsFixed(0)} ج.م للحصول على شحن مجاني',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
          const Divider(height: 24),
          _SummaryRow(
            l10n.total,
            '${total.toStringAsFixed(2)}\ج.م',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

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
          style: style?.copyWith(
            color: bold ? AppColors.gold : null,
            fontWeight: bold ? FontWeight.w700 : null,
          ),
        ),
      ],
    );
  }
}
