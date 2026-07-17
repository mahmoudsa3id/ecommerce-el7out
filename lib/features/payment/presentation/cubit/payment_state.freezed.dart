// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaymentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
    PaymentState value,
    $Res Function(PaymentState) then,
  ) = _$PaymentStateCopyWithImpl<$Res, PaymentState>;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PaymentInitialImplCopyWith<$Res> {
  factory _$$PaymentInitialImplCopyWith(
    _$PaymentInitialImpl value,
    $Res Function(_$PaymentInitialImpl) then,
  ) = __$$PaymentInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentInitialImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentInitialImpl>
    implements _$$PaymentInitialImplCopyWith<$Res> {
  __$$PaymentInitialImplCopyWithImpl(
    _$PaymentInitialImpl _value,
    $Res Function(_$PaymentInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentInitialImpl implements PaymentInitial {
  const _$PaymentInitialImpl();

  @override
  String toString() {
    return 'PaymentState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
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
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PaymentInitial implements PaymentState {
  const factory PaymentInitial() = _$PaymentInitialImpl;
}

/// @nodoc
abstract class _$$PaymentDraftReadyImplCopyWith<$Res> {
  factory _$$PaymentDraftReadyImplCopyWith(
    _$PaymentDraftReadyImpl value,
    $Res Function(_$PaymentDraftReadyImpl) then,
  ) = __$$PaymentDraftReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PendingOrderDraft d});
}

/// @nodoc
class __$$PaymentDraftReadyImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentDraftReadyImpl>
    implements _$$PaymentDraftReadyImplCopyWith<$Res> {
  __$$PaymentDraftReadyImplCopyWithImpl(
    _$PaymentDraftReadyImpl _value,
    $Res Function(_$PaymentDraftReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? d = null}) {
    return _then(
      _$PaymentDraftReadyImpl(
        null == d
            ? _value.d
            : d // ignore: cast_nullable_to_non_nullable
                  as PendingOrderDraft,
      ),
    );
  }
}

/// @nodoc

class _$PaymentDraftReadyImpl implements PaymentDraftReady {
  const _$PaymentDraftReadyImpl(this.d);

  @override
  final PendingOrderDraft d;

  @override
  String toString() {
    return 'PaymentState.draftReady(d: $d)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentDraftReadyImpl &&
            (identical(other.d, d) || other.d == d));
  }

  @override
  int get hashCode => Object.hash(runtimeType, d);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentDraftReadyImplCopyWith<_$PaymentDraftReadyImpl> get copyWith =>
      __$$PaymentDraftReadyImplCopyWithImpl<_$PaymentDraftReadyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return draftReady(d);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return draftReady?.call(d);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (draftReady != null) {
      return draftReady(d);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return draftReady(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return draftReady?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (draftReady != null) {
      return draftReady(this);
    }
    return orElse();
  }
}

abstract class PaymentDraftReady implements PaymentState {
  const factory PaymentDraftReady(final PendingOrderDraft d) =
      _$PaymentDraftReadyImpl;

  PendingOrderDraft get d;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentDraftReadyImplCopyWith<_$PaymentDraftReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentLoadingKeyImplCopyWith<$Res> {
  factory _$$PaymentLoadingKeyImplCopyWith(
    _$PaymentLoadingKeyImpl value,
    $Res Function(_$PaymentLoadingKeyImpl) then,
  ) = __$$PaymentLoadingKeyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentLoadingKeyImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentLoadingKeyImpl>
    implements _$$PaymentLoadingKeyImplCopyWith<$Res> {
  __$$PaymentLoadingKeyImplCopyWithImpl(
    _$PaymentLoadingKeyImpl _value,
    $Res Function(_$PaymentLoadingKeyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentLoadingKeyImpl implements PaymentLoadingKey {
  const _$PaymentLoadingKeyImpl();

  @override
  String toString() {
    return 'PaymentState.loadingKey()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentLoadingKeyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return loadingKey();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return loadingKey?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loadingKey != null) {
      return loadingKey();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return loadingKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return loadingKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (loadingKey != null) {
      return loadingKey(this);
    }
    return orElse();
  }
}

abstract class PaymentLoadingKey implements PaymentState {
  const factory PaymentLoadingKey() = _$PaymentLoadingKeyImpl;
}

/// @nodoc
abstract class _$$PaymentKeyReadyImplCopyWith<$Res> {
  factory _$$PaymentKeyReadyImplCopyWith(
    _$PaymentKeyReadyImpl value,
    $Res Function(_$PaymentKeyReadyImpl) then,
  ) = __$$PaymentKeyReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String paymentKey});
}

/// @nodoc
class __$$PaymentKeyReadyImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentKeyReadyImpl>
    implements _$$PaymentKeyReadyImplCopyWith<$Res> {
  __$$PaymentKeyReadyImplCopyWithImpl(
    _$PaymentKeyReadyImpl _value,
    $Res Function(_$PaymentKeyReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? paymentKey = null}) {
    return _then(
      _$PaymentKeyReadyImpl(
        null == paymentKey
            ? _value.paymentKey
            : paymentKey // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PaymentKeyReadyImpl implements PaymentKeyReady {
  const _$PaymentKeyReadyImpl(this.paymentKey);

  @override
  final String paymentKey;

  @override
  String toString() {
    return 'PaymentState.keyReady(paymentKey: $paymentKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentKeyReadyImpl &&
            (identical(other.paymentKey, paymentKey) ||
                other.paymentKey == paymentKey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, paymentKey);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentKeyReadyImplCopyWith<_$PaymentKeyReadyImpl> get copyWith =>
      __$$PaymentKeyReadyImplCopyWithImpl<_$PaymentKeyReadyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return keyReady(paymentKey);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return keyReady?.call(paymentKey);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (keyReady != null) {
      return keyReady(paymentKey);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return keyReady(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return keyReady?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (keyReady != null) {
      return keyReady(this);
    }
    return orElse();
  }
}

abstract class PaymentKeyReady implements PaymentState {
  const factory PaymentKeyReady(final String paymentKey) =
      _$PaymentKeyReadyImpl;

  String get paymentKey;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentKeyReadyImplCopyWith<_$PaymentKeyReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentUploadingProofImplCopyWith<$Res> {
  factory _$$PaymentUploadingProofImplCopyWith(
    _$PaymentUploadingProofImpl value,
    $Res Function(_$PaymentUploadingProofImpl) then,
  ) = __$$PaymentUploadingProofImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentUploadingProofImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentUploadingProofImpl>
    implements _$$PaymentUploadingProofImplCopyWith<$Res> {
  __$$PaymentUploadingProofImplCopyWithImpl(
    _$PaymentUploadingProofImpl _value,
    $Res Function(_$PaymentUploadingProofImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentUploadingProofImpl implements PaymentUploadingProof {
  const _$PaymentUploadingProofImpl();

  @override
  String toString() {
    return 'PaymentState.uploadingProof()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentUploadingProofImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return uploadingProof();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return uploadingProof?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (uploadingProof != null) {
      return uploadingProof();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return uploadingProof(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return uploadingProof?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (uploadingProof != null) {
      return uploadingProof(this);
    }
    return orElse();
  }
}

abstract class PaymentUploadingProof implements PaymentState {
  const factory PaymentUploadingProof() = _$PaymentUploadingProofImpl;
}

/// @nodoc
abstract class _$$PaymentCreatingOrderImplCopyWith<$Res> {
  factory _$$PaymentCreatingOrderImplCopyWith(
    _$PaymentCreatingOrderImpl value,
    $Res Function(_$PaymentCreatingOrderImpl) then,
  ) = __$$PaymentCreatingOrderImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentCreatingOrderImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentCreatingOrderImpl>
    implements _$$PaymentCreatingOrderImplCopyWith<$Res> {
  __$$PaymentCreatingOrderImplCopyWithImpl(
    _$PaymentCreatingOrderImpl _value,
    $Res Function(_$PaymentCreatingOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentCreatingOrderImpl implements PaymentCreatingOrder {
  const _$PaymentCreatingOrderImpl();

  @override
  String toString() {
    return 'PaymentState.creatingOrder()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentCreatingOrderImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return creatingOrder();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return creatingOrder?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (creatingOrder != null) {
      return creatingOrder();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return creatingOrder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return creatingOrder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (creatingOrder != null) {
      return creatingOrder(this);
    }
    return orElse();
  }
}

abstract class PaymentCreatingOrder implements PaymentState {
  const factory PaymentCreatingOrder() = _$PaymentCreatingOrderImpl;
}

/// @nodoc
abstract class _$$PaymentSuccessImplCopyWith<$Res> {
  factory _$$PaymentSuccessImplCopyWith(
    _$PaymentSuccessImpl value,
    $Res Function(_$PaymentSuccessImpl) then,
  ) = __$$PaymentSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OrderEntity order});
}

/// @nodoc
class __$$PaymentSuccessImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentSuccessImpl>
    implements _$$PaymentSuccessImplCopyWith<$Res> {
  __$$PaymentSuccessImplCopyWithImpl(
    _$PaymentSuccessImpl _value,
    $Res Function(_$PaymentSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? order = null}) {
    return _then(
      _$PaymentSuccessImpl(
        null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as OrderEntity,
      ),
    );
  }
}

/// @nodoc

class _$PaymentSuccessImpl implements PaymentSuccess {
  const _$PaymentSuccessImpl(this.order);

  @override
  final OrderEntity order;

  @override
  String toString() {
    return 'PaymentState.success(order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSuccessImpl &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      __$$PaymentSuccessImplCopyWithImpl<_$PaymentSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return success(order);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return success?.call(order);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(order);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PaymentSuccess implements PaymentState {
  const factory PaymentSuccess(final OrderEntity order) = _$PaymentSuccessImpl;

  OrderEntity get order;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentFailedImplCopyWith<$Res> {
  factory _$$PaymentFailedImplCopyWith(
    _$PaymentFailedImpl value,
    $Res Function(_$PaymentFailedImpl) then,
  ) = __$$PaymentFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentFailedImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentFailedImpl>
    implements _$$PaymentFailedImplCopyWith<$Res> {
  __$$PaymentFailedImplCopyWithImpl(
    _$PaymentFailedImpl _value,
    $Res Function(_$PaymentFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentFailedImpl implements PaymentFailed {
  const _$PaymentFailedImpl();

  @override
  String toString() {
    return 'PaymentState.paymentFailed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentFailedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return paymentFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return paymentFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (paymentFailed != null) {
      return paymentFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return paymentFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return paymentFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (paymentFailed != null) {
      return paymentFailed(this);
    }
    return orElse();
  }
}

abstract class PaymentFailed implements PaymentState {
  const factory PaymentFailed() = _$PaymentFailedImpl;
}

/// @nodoc
abstract class _$$PaymentErrorImplCopyWith<$Res> {
  factory _$$PaymentErrorImplCopyWith(
    _$PaymentErrorImpl value,
    $Res Function(_$PaymentErrorImpl) then,
  ) = __$$PaymentErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PaymentErrorImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentErrorImpl>
    implements _$$PaymentErrorImplCopyWith<$Res> {
  __$$PaymentErrorImplCopyWithImpl(
    _$PaymentErrorImpl _value,
    $Res Function(_$PaymentErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PaymentErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PaymentErrorImpl implements PaymentError {
  const _$PaymentErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      __$$PaymentErrorImplCopyWithImpl<_$PaymentErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(PendingOrderDraft d) draftReady,
    required TResult Function() loadingKey,
    required TResult Function(String paymentKey) keyReady,
    required TResult Function() uploadingProof,
    required TResult Function() creatingOrder,
    required TResult Function(OrderEntity order) success,
    required TResult Function() paymentFailed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(PendingOrderDraft d)? draftReady,
    TResult? Function()? loadingKey,
    TResult? Function(String paymentKey)? keyReady,
    TResult? Function()? uploadingProof,
    TResult? Function()? creatingOrder,
    TResult? Function(OrderEntity order)? success,
    TResult? Function()? paymentFailed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(PendingOrderDraft d)? draftReady,
    TResult Function()? loadingKey,
    TResult Function(String paymentKey)? keyReady,
    TResult Function()? uploadingProof,
    TResult Function()? creatingOrder,
    TResult Function(OrderEntity order)? success,
    TResult Function()? paymentFailed,
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
    required TResult Function(PaymentInitial value) initial,
    required TResult Function(PaymentDraftReady value) draftReady,
    required TResult Function(PaymentLoadingKey value) loadingKey,
    required TResult Function(PaymentKeyReady value) keyReady,
    required TResult Function(PaymentUploadingProof value) uploadingProof,
    required TResult Function(PaymentCreatingOrder value) creatingOrder,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) paymentFailed,
    required TResult Function(PaymentError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentInitial value)? initial,
    TResult? Function(PaymentDraftReady value)? draftReady,
    TResult? Function(PaymentLoadingKey value)? loadingKey,
    TResult? Function(PaymentKeyReady value)? keyReady,
    TResult? Function(PaymentUploadingProof value)? uploadingProof,
    TResult? Function(PaymentCreatingOrder value)? creatingOrder,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? paymentFailed,
    TResult? Function(PaymentError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentInitial value)? initial,
    TResult Function(PaymentDraftReady value)? draftReady,
    TResult Function(PaymentLoadingKey value)? loadingKey,
    TResult Function(PaymentKeyReady value)? keyReady,
    TResult Function(PaymentUploadingProof value)? uploadingProof,
    TResult Function(PaymentCreatingOrder value)? creatingOrder,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? paymentFailed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PaymentError implements PaymentState {
  const factory PaymentError(final String message) = _$PaymentErrorImpl;

  String get message;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
