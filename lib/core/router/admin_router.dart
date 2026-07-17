import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_categories_page.dart';
import '../../features/admin/presentation/pages/admin_products_page.dart';
import '../../features/admin/presentation/pages/admin_orders_page.dart';
import '../../features/admin/presentation/pages/admin_order_detail_page.dart';
import '../../features/admin/presentation/pages/admin_category_form_page.dart';
import '../../features/admin/presentation/pages/admin_product_form_page.dart';

import '../../features/admin/presentation/cubit/admin_category_cubit.dart';
import '../../features/admin/presentation/cubit/admin_product_cubit.dart';

final adminRouter = GoRouter(
  initialLocation: RoutePaths.adminDashboard,
  routes: [
    GoRoute(
      path: RoutePaths.adminDashboard,
      builder: (context, state) => const AdminDashboardPage(),
    ),

    GoRoute(
      path: RoutePaths.adminCategories,
      builder: (context, state) => const AdminCategoriesPage(),
    ),

    GoRoute(
      path: RoutePaths.adminCategoryAdd,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminCategoryCubit(),
        child: const AdminCategoryFormPage(),
      ),
    ),

    GoRoute(
      path: RoutePaths.adminCategoryEdit,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminCategoryCubit(),
        child: AdminCategoryFormPage(categoryId: state.pathParameters['id']),
      ),
    ),

    GoRoute(
      path: RoutePaths.adminProducts,
      builder: (context, state) => const AdminProductsPage(),
    ),

    GoRoute(
      path: RoutePaths.adminProductAdd,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminProductCubit(),
        child: const AdminProductFormPage(),
      ),
    ),

    GoRoute(
      path: RoutePaths.adminProductEdit,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminProductCubit(),
        child: AdminProductFormPage(productId: state.pathParameters['id']),
      ),
    ),

    GoRoute(
      path: RoutePaths.adminOrders,
      builder: (context, state) => const AdminOrdersPage(),
    ),

    GoRoute(
      path: RoutePaths.adminOrderDetailRoute,
      builder: (context, state) =>
          AdminOrderDetailPage(orderId: state.pathParameters['orderId']!),
    ),
  ],
);
