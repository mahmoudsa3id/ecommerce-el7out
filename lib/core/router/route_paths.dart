abstract class RoutePaths {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/';

  static const categories = '/categories';
  static const categoryDetail = '/categories/:slug';

  static const productDetails = '/product/:id';

  static const search = '/search';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const checkout = '/checkout';

  static const orders = '/orders';
  static const orderDetail = '/orders/:orderId';

  static const profile = '/profile';
  static const notifications = '/notifications';
  static const settings = '/settings';

  static const authGate = '/auth-gate';

  // =========================
  // Admin
  // =========================

  static const adminDashboard = '/admin';

  static const adminProducts = '/admin/products';
  static const adminProductAdd = '/admin/products/add';
  static const adminProductEdit = '/admin/products/edit/:id';

  static const adminCategories = '/admin/categories';
  static const adminCategoryAdd = '/admin/categories/add';
  static const adminCategoryEdit = '/admin/categories/edit/:id';

  static const adminOrders = '/admin/orders';
  static const adminOrderDetailRoute = '/admin/orders/:orderId';

  // =========================
  // Dynamic Paths
  // =========================

  static String productDetailsPath(String id) => '/product/$id';

  static String categoryDetailPath(String slug) => '/categories/$slug';

  static String orderDetailPath(String orderId) => '/orders/$orderId';

  static String adminOrderDetail(String orderId) => '/admin/orders/$orderId';

  static String adminCategoryEditPath(String id) =>
      '/admin/categories/edit/$id';

  static String adminProductEditPath(String id) => '/admin/products/edit/$id';
}
