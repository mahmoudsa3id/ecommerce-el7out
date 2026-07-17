// features/auth/domain/usecases/sign_up_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;
  const SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    if (params.fullName.trim().length < 2) {
      return Future.value(
        const Left(ValidationFailure('Please enter your full name.')),
      );
    }
    if (!params.email.contains('@')) {
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
    return repository.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String fullName;
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}
