// features/auth/presentation/cubit/auth_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final AuthRepository authRepository;
  StreamSubscription? _authSub;

  AuthCubit(this.signInUseCase, this.signUpUseCase, this.authRepository)
    : super(const AuthState.initial()) {
    _authSub = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else if (state is! AuthLoading) {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthState.loading());
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(const AuthState.loading());
    final result = await signUpUseCase(
      SignUpParams(email: email, password: password, fullName: fullName),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());
    final result = await authRepository.signOut();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
