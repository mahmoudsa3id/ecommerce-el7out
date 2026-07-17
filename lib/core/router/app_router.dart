// core/router/app_router.dart  (FULL REPLACEMENT – guest-mode aware)
import 'package:ecommerce_el7out/features/auth/presentation/pages/auth_gate_page.dart';
import 'package:ecommerce_el7out/features/cart/presentation/pages/cart_page.dart';
import 'package:ecommerce_el7out/features/category/presentation/pages/category_detai_page.dart';
import 'package:ecommerce_el7out/features/category/presentation/pages/category_page.dart';
import 'package:ecommerce_el7out/features/checkout/presentation/pages/check_out_pages.dart';
import 'package:ecommerce_el7out/features/notification/presentation/pages/notification_page.dart';
import 'package:ecommerce_el7out/features/order/presentation/pages/order_page.dart';
import 'package:ecommerce_el7out/features/order/presentation/pages/order_page_details.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/home_pages.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/product_detail_page.dart';
import 'package:ecommerce_el7out/features/profile/presentation/pages/profile_page.dart';
import 'package:ecommerce_el7out/features/search/presentation/pages/search_page.dart';
import 'package:ecommerce_el7out/features/settings/presentation/pages/settings_page.dart';
import 'package:ecommerce_el7out/features/shell/presentation/pages/shell_page.dart';
import 'package:ecommerce_el7out/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'route_paths.dart';

CustomTransitionPage<T> _fadeSlidePage<T>(Widget child, GoRouterState state) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 360),
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  refreshListenable: _GoRouterRefreshStream(getIt<AuthCubit>().stream),
  redirect: (context, state) {
    final loc = state.matchedLocation;

    final isPublicRoute =
        loc == RoutePaths.onboarding ||
        loc == RoutePaths.login ||
        loc == RoutePaths.register ||
        loc == RoutePaths.authGate;

    if (isPublicRoute) {
      return null;
    }

    // Guest mode enabled:
    // لا توجد أي صفحة تتطلب تسجيل الدخول أثناء الشراء.
    return null;
  },
  routes: [
    GoRoute(
      path: RoutePaths.login,
      pageBuilder: (c, s) {
        final redirect = s.uri.queryParameters['redirect'] ?? RoutePaths.home;
        return _fadeSlidePage(AuthGatePage(redirectPath: redirect), s);
      },
    ),
    GoRoute(
      path: RoutePaths.register,
      pageBuilder: (c, s) {
        final redirect = s.uri.queryParameters['redirect'] ?? RoutePaths.home;
        return _fadeSlidePage(
          AuthGatePage(redirectPath: redirect, initialTabIndex: 1),
          s,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.authGate,
      pageBuilder: (c, s) {
        final redirect = s.uri.queryParameters['redirect'] ?? RoutePaths.home;
        return _fadeSlidePage(AuthGatePage(redirectPath: redirect), s);
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.home,
          pageBuilder: (c, s) => _fadeSlidePage(const HomePage(), s),
        ),
        GoRoute(
          path: RoutePaths.categories,
          pageBuilder: (c, s) => _fadeSlidePage(const CategoriesPage(), s),
          routes: [
            GoRoute(
              path: ':slug',
              pageBuilder: (c, s) => _fadeSlidePage(
                CategoryDetailPage(slug: s.pathParameters['slug']!),
                s,
              ),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.productDetails,
          pageBuilder: (c, s) => _fadeSlidePage(
            ProductDetailsPage(productId: s.pathParameters['id']!),
            s,
          ),
        ),
        GoRoute(
          path: RoutePaths.search,
          pageBuilder: (c, s) => _fadeSlidePage(const SearchPage(), s),
        ),
        GoRoute(
          path: RoutePaths.wishlist,
          pageBuilder: (c, s) => _fadeSlidePage(const WishlistPage(), s),
        ),
        GoRoute(
          path: RoutePaths.cart,
          pageBuilder: (c, s) => _fadeSlidePage(const CartPage(), s),
        ),
        GoRoute(
          path: RoutePaths.checkout,
          pageBuilder: (c, s) => _fadeSlidePage(const CheckoutPage(), s),
        ),
        GoRoute(
          path: RoutePaths.orders,
          pageBuilder: (c, s) => _fadeSlidePage(const OrdersPage(), s),
          routes: [
            GoRoute(
              path: ':orderId',
              pageBuilder: (c, s) => _fadeSlidePage(
                OrderDetailPage(orderId: s.pathParameters['orderId']!),
                s,
              ),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.profile,
          pageBuilder: (c, s) => _fadeSlidePage(const ProfilePage(), s),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          pageBuilder: (c, s) => _fadeSlidePage(const NotificationsPage(), s),
        ),
        GoRoute(
          path: RoutePaths.settings,
          pageBuilder: (c, s) => _fadeSlidePage(const SettingsPage(), s),
        ),
      ],
    ),
  ],
);

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
