// ============================================================
// features/payment/presentation/pages/paymob_wallet_page.dart
// ============================================================
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/payment_entity.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import 'card_payment_page.dart';

class PayMobWalletPage extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final AddressEntity billingAddress;

  const PayMobWalletPage({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.billingAddress,
  });

  @override
  State<PayMobWalletPage> createState() => _PayMobWalletPageState();
}

class _PayMobWalletPageState extends State<PayMobWalletPage> {
  WebViewController? _webCtrl;
  bool _webViewReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentCubit>().getWalletPaymentKey();
    });
  }

  void _initWebView(String paymentKey) {
    final url =
        'https://accept.paymob.com/api/acceptance/iframes/${AppConstants.paymobIframeId}?payment_token=$paymentKey';
    final ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onUrlChange: (c) => _handleUrl(c.url ?? '')),
      )
      ..loadRequest(Uri.parse(url));
    setState(() {
      _webCtrl = ctrl;
      _webViewReady = true;
    });
  }

  void _handleUrl(String url) {
    if (url.contains('success=true')) {
      final txId = Uri.parse(url).queryParameters['id'] ?? '';
      context.read<PaymentCubit>().verifyTransaction(
        orderId: widget.orderId,
        transactionId: txId,
        amount: widget.totalAmount,
        method: PaymentMethodType.paymobWallet,
      );
    } else if (url.contains('success=false')) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          keyReady: _initWebView,
          success: (_) => Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) context.go(RoutePaths.orders);
          }),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('MOBILE WALLET PAYMENT')),
          body: state.maybeWhen(
            loadingKey: () => const _LoadingView(message: 'Connecting...'),
            uploadingProof: () => const _LoadingView(message: 'Processing...'),
            creatingOrder: () => const _LoadingView(message: 'Creating your order...'),
            keyReady: (_) => _webViewReady && _webCtrl != null
                ? WebViewWidget(controller: _webCtrl!)
                : const _LoadingView(message: 'Loading...'),
            success: (p) => const _LoadingView(message: 'Payment confirmed!'),
            error: (msg) => Center(child: Text(msg)),
            orElse: () =>
                const _LoadingView(message: 'Preparing wallet payment...'),
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatefulWidget {
  final String message;

  const _LoadingView({required this.message});

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? const [Color(0xff111827), Color(0xff1F2937), Color(0xff111827)]
              : const [Color(0xffF8FAFC), Color(0xffEEF2F7), Color(0xffF8FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Transform.scale(
                scale: 0.95 + (_controller.value * .08),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: dark ? Colors.white.withOpacity(.06) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: dark ? Colors.white12 : Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Please wait while we securely process your payment.",
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          backgroundColor: Theme.of(
                            context,
                          ).dividerColor.withOpacity(.2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
