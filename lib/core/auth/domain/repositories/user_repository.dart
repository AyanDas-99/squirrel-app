import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/tokenParam.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signup(UsernameAndPassword usernameAndPassword);
  Future<Either<Failure, Tokenparam<User>>> login(
    UsernameAndPassword usernameAndPassword,
  );
  Future<Either<Failure, AuthToken>> getLocalToken();
  Future<Either<Failure, User>> validateToken(AuthToken authToken);
  Future<Either<Failure, bool>> logout();
}

class UsernameAndPassword {
  final String username;
  final String password;

  UsernameAndPassword({required this.username, required this.password});
}
