import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';

class ValidateToken implements Usecase<User, AuthToken> {
  final UserRepository repository;

  ValidateToken(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthToken token) async {
    return await repository.validateToken(token);
  }
}

