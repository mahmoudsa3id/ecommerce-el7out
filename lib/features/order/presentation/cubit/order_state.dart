// features/orders/presentation/cubit/order_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = OrderInitial;
  const factory OrderState.loading() = OrderLoading;
  const factory OrderState.loaded(List<OrderEntity> orders) = OrderLoaded;
  const factory OrderState.placing() = OrderPlacing;
  const factory OrderState.placed(OrderEntity order) = OrderPlaced;
  const factory OrderState.error(String message) = OrderError;
}
