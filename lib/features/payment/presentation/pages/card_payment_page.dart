// ============================================================
// features/payment/presentation/pages/card_payment_page.dart
// Full PayMob card payment via WebView
// ============================================================
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
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

class CardPaymentPage extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final AddressEntity billingAddress;

  const CardPaymentPage({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.billingAddress,
  });

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  WebViewController? _webCtrl;
  bool _webViewReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentCubit>().getCardPaymentKey();
    });
  }

  void _initWebView(String paymentKey) {
    final iframeUrl =
        'https://accept.paymob.com/api/acceptance/iframes/${AppConstants.paymobIframeId}?payment_token=$paymentKey';

    final ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) => _handleUrlChange(change.url ?? ''),
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    setState(() {
      _webCtrl = ctrl;
      _webViewReady = true;
    });
  }

  void _handleUrlChange(String url) {
    // PayMob redirects to success/fail callback
    if (url.contains('success=true') || url.contains('is_billed=1')) {
      final uri = Uri.parse(url);
      final txId = uri.queryParameters['id'] ?? '';
      context.read<PaymentCubit>().verifyTransaction(
        orderId: widget.orderId,
        transactionId: txId,
        amount: widget.totalAmount,
        method: PaymentMethodType.card,
      );
    } else if (url.contains('success=false') || url.contains('is_void=1')) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل الدفع حاول مرة اخرى'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          keyReady: (key) => _initWebView(key),
          success: (_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              context.go(RoutePaths.orders);
            });
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('دفع أمن'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: const [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'SSL',
                      style: TextStyle(fontSize: 11, color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: state.maybeWhen(
            loadingKey: () =>
                const _LoadingView(message: 'Connecting to payment gateway...'),
            uploadingProof: () => const _LoadingView(message: 'Processing...'),
            creatingOrder: () =>
                const _LoadingView(message: 'Creating your order...'),
            keyReady: (_) => _webViewReady && _webCtrl != null
                ? WebViewWidget(controller: _webCtrl!)
                : const _LoadingView(message: 'Loading payment form...'),
            success: (payment) => _SuccessOverlay(payment: payment),
            error: (msg) => _ErrorView(
              message: msg,
              onRetry: () {
                context.read<PaymentCubit>().getCardPaymentKey();
              },
            ),
            orElse: () =>
                const _LoadingView(message: 'Preparing secure payment...'),
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  final String message;
  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeSlideIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 2.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _SuccessOverlay extends StatelessWidget {
  final dynamic payment;
  const _SuccessOverlay({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withOpacity(0.1),
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 52,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Payment Successful!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Redirecting to your orders...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(onPressed: onRetry, child: const Text('RETRY')),
          ],
        ),
      ),
    );
  }
}
