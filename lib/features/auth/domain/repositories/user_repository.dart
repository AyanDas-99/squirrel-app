import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signup(UsernameAndPassword usernameAndPassword);
  Future<Either<Failure, AuthToken>> login(
      UsernameAndPassword usernameAndPassword);
}

class UsernameAndPassword {
  final String username;
  final String password;

  UsernameAndPassword({required this.username, required this.password});
}
