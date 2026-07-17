// features/orders/presentation/cubit/order_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/features/order/domain/repository/order_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/order_entity.dart';
import 'order_state.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;
  final AuthCubit _authCubit;
  final CartCubit _cartCubit;
  final AnalyticsService _analytics;

  OrderCubit(
    this._repository,
    this._authCubit,
    this._cartCubit,
    this._analytics,
  ) : super(const OrderState.initial());

  Future<void> loadOrders() async {
    final auth = _authCubit.state;
    if (auth is! AuthAuthenticated) {
      emit(const OrderState.error('Please sign in to view your orders.'));
      return;
    }
    emit(const OrderState.loading());
    final result = await _repository.getOrders(auth.user.id);
    result.fold(
      (f) => emit(OrderState.error(f.message)),
      (orders) => emit(OrderState.loaded(orders)),
    );
  }

  Future<void> placeOrder({
    required AddressEntity address,
    required String paymentMethod,
  }) async {
    final auth = _authCubit.state;
    if (auth is! AuthAuthenticated) {
      emit(const OrderState.error('Authentication required.'));
      return;
    }

    final cartItems = _cartCubit.state.maybeWhen(
      loaded: (items) => items,
      orElse: () => [],
    );

    if (cartItems.isEmpty) {
      emit(const OrderState.error('Your bag is empty.'));
      return;
    }

    emit(const OrderState.placing());
    final result = await _repository.placeOrder(
      userId: auth.user.id,
      items: cartItems,
      address: address,
      paymentMethod: paymentMethod,
    );

    await result.fold((f) async => emit(OrderState.error(f.message)), (
      order,
    ) async {
      await _cartCubit.clearCart();
      await _analytics.logPurchase(
        orderId: order.id,
        value: order.pricing.total,
        items: order.items
            .map(
              (i) => {
                'id': i.productId,
                'name': i.productName,
                'price': i.totalPrice,
                'quantity': i.quantity,
              },
            )
            .toList(),
      );
      emit(OrderState.placed(order));
    });
  }
}
