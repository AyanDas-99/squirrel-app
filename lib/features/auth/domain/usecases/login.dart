import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/auth/domain/repositories/user_repository.dart';

class Login implements Usecase<AuthToken, UsernameAndPassword> {
  final UserRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, AuthToken>> call(
      UsernameAndPassword usernameAndPassword) async {
    return await repository.login(usernameAndPassword);
  }
}
