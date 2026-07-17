// features/auth/domain/usecases/sign_in_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;
  const SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    if (params.email.trim().isEmpty || !params.email.contains('@')) {
      return Future.value(
        const Left(ValidationFailure('Please enter a valid email.')),
      );
    }
    if (params.password.length < 6) {
      return Future.value(
        const Left(
          ValidationFailure('Password must be at least 6 characters.'),
        ),
      );
    }
    return repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
