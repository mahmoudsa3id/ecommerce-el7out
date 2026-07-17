// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStateCopyWith<$Res> {
  factory $OrderStateCopyWith(
    OrderState value,
    $Res Function(OrderState) then,
  ) = _$OrderStateCopyWithImpl<$Res, OrderState>;
}

/// @nodoc
class _$OrderStateCopyWithImpl<$Res, $Val extends OrderState>
    implements $OrderStateCopyWith<$Res> {
  _$OrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OrderInitialImplCopyWith<$Res> {
  factory _$$OrderInitialImplCopyWith(
    _$OrderInitialImpl value,
    $Res Function(_$OrderInitialImpl) then,
  ) = __$$OrderInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OrderInitialImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderInitialImpl>
    implements _$$OrderInitialImplCopyWith<$Res> {
  __$$OrderInitialImplCopyWithImpl(
    _$OrderInitialImpl _value,
    $Res Function(_$OrderInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OrderInitialImpl implements OrderInitial {
  const _$OrderInitialImpl();

  @override
  String toString() {
    return 'OrderState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OrderInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class OrderInitial implements OrderState {
  const factory OrderInitial() = _$OrderInitialImpl;
}

/// @nodoc
abstract class _$$OrderLoadingImplCopyWith<$Res> {
  factory _$$OrderLoadingImplCopyWith(
    _$OrderLoadingImpl value,
    $Res Function(_$OrderLoadingImpl) then,
  ) = __$$OrderLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OrderLoadingImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderLoadingImpl>
    implements _$$OrderLoadingImplCopyWith<$Res> {
  __$$OrderLoadingImplCopyWithImpl(
    _$OrderLoadingImpl _value,
    $Res Function(_$OrderLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OrderLoadingImpl implements OrderLoading {
  const _$OrderLoadingImpl();

  @override
  String toString() {
    return 'OrderState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OrderLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class OrderLoading implements OrderState {
  const factory OrderLoading() = _$OrderLoadingImpl;
}

/// @nodoc
abstract class _$$OrderLoadedImplCopyWith<$Res> {
  factory _$$OrderLoadedImplCopyWith(
    _$OrderLoadedImpl value,
    $Res Function(_$OrderLoadedImpl) then,
  ) = __$$OrderLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<OrderEntity> orders});
}

/// @nodoc
class __$$OrderLoadedImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderLoadedImpl>
    implements _$$OrderLoadedImplCopyWith<$Res> {
  __$$OrderLoadedImplCopyWithImpl(
    _$OrderLoadedImpl _value,
    $Res Function(_$OrderLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orders = null}) {
    return _then(
      _$OrderLoadedImpl(
        null == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<OrderEntity>,
      ),
    );
  }
}

/// @nodoc

class _$OrderLoadedImpl implements OrderLoaded {
  const _$OrderLoadedImpl(final List<OrderEntity> orders) : _orders = orders;

  final List<OrderEntity> _orders;
  @override
  List<OrderEntity> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  String toString() {
    return 'OrderState.loaded(orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLoadedImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_orders));

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLoadedImplCopyWith<_$OrderLoadedImpl> get copyWith =>
      __$$OrderLoadedImplCopyWithImpl<_$OrderLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return loaded(orders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(orders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(orders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class OrderLoaded implements OrderState {
  const factory OrderLoaded(final List<OrderEntity> orders) = _$OrderLoadedImpl;

  List<OrderEntity> get orders;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderLoadedImplCopyWith<_$OrderLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OrderPlacingImplCopyWith<$Res> {
  factory _$$OrderPlacingImplCopyWith(
    _$OrderPlacingImpl value,
    $Res Function(_$OrderPlacingImpl) then,
  ) = __$$OrderPlacingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OrderPlacingImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderPlacingImpl>
    implements _$$OrderPlacingImplCopyWith<$Res> {
  __$$OrderPlacingImplCopyWithImpl(
    _$OrderPlacingImpl _value,
    $Res Function(_$OrderPlacingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OrderPlacingImpl implements OrderPlacing {
  const _$OrderPlacingImpl();

  @override
  String toString() {
    return 'OrderState.placing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OrderPlacingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return placing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return placing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (placing != null) {
      return placing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return placing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return placing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (placing != null) {
      return placing(this);
    }
    return orElse();
  }
}

abstract class OrderPlacing implements OrderState {
  const factory OrderPlacing() = _$OrderPlacingImpl;
}

/// @nodoc
abstract class _$$OrderPlacedImplCopyWith<$Res> {
  factory _$$OrderPlacedImplCopyWith(
    _$OrderPlacedImpl value,
    $Res Function(_$OrderPlacedImpl) then,
  ) = __$$OrderPlacedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OrderEntity order});
}

/// @nodoc
class __$$OrderPlacedImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderPlacedImpl>
    implements _$$OrderPlacedImplCopyWith<$Res> {
  __$$OrderPlacedImplCopyWithImpl(
    _$OrderPlacedImpl _value,
    $Res Function(_$OrderPlacedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? order = null}) {
    return _then(
      _$OrderPlacedImpl(
        null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as OrderEntity,
      ),
    );
  }
}

/// @nodoc

class _$OrderPlacedImpl implements OrderPlaced {
  const _$OrderPlacedImpl(this.order);

  @override
  final OrderEntity order;

  @override
  String toString() {
    return 'OrderState.placed(order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPlacedImpl &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPlacedImplCopyWith<_$OrderPlacedImpl> get copyWith =>
      __$$OrderPlacedImplCopyWithImpl<_$OrderPlacedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return placed(order);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return placed?.call(order);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (placed != null) {
      return placed(order);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return placed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return placed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (placed != null) {
      return placed(this);
    }
    return orElse();
  }
}

abstract class OrderPlaced implements OrderState {
  const factory OrderPlaced(final OrderEntity order) = _$OrderPlacedImpl;

  OrderEntity get order;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPlacedImplCopyWith<_$OrderPlacedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OrderErrorImplCopyWith<$Res> {
  factory _$$OrderErrorImplCopyWith(
    _$OrderErrorImpl value,
    $Res Function(_$OrderErrorImpl) then,
  ) = __$$OrderErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$OrderErrorImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderErrorImpl>
    implements _$$OrderErrorImplCopyWith<$Res> {
  __$$OrderErrorImplCopyWithImpl(
    _$OrderErrorImpl _value,
    $Res Function(_$OrderErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$OrderErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OrderErrorImpl implements OrderError {
  const _$OrderErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'OrderState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderErrorImplCopyWith<_$OrderErrorImpl> get copyWith =>
      __$$OrderErrorImplCopyWithImpl<_$OrderErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderEntity> orders) loaded,
    required TResult Function() placing,
    required TResult Function(OrderEntity order) placed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderEntity> orders)? loaded,
    TResult? Function()? placing,
    TResult? Function(OrderEntity order)? placed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderEntity> orders)? loaded,
    TResult Function()? placing,
    TResult Function(OrderEntity order)? placed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OrderInitial value) initial,
    required TResult Function(OrderLoading value) loading,
    required TResult Function(OrderLoaded value) loaded,
    required TResult Function(OrderPlacing value) placing,
    required TResult Function(OrderPlaced value) placed,
    required TResult Function(OrderError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OrderInitial value)? initial,
    TResult? Function(OrderLoading value)? loading,
    TResult? Function(OrderLoaded value)? loaded,
    TResult? Function(OrderPlacing value)? placing,
    TResult? Function(OrderPlaced value)? placed,
    TResult? Function(OrderError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OrderInitial value)? initial,
    TResult Function(OrderLoading value)? loading,
    TResult Function(OrderLoaded value)? loaded,
    TResult Function(OrderPlacing value)? placing,
    TResult Function(OrderPlaced value)? placed,
    TResult Function(OrderError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OrderError implements OrderState {
  const factory OrderError(final String message) = _$OrderErrorImpl;

  String get message;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderErrorImplCopyWith<_$OrderErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
