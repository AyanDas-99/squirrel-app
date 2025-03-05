import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:squirrel_app/features/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/features/auth/domain/entities/user.dart';
import 'package:squirrel_app/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthDataSource authDataSource;

  UserRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, AuthToken>> login(
      UsernameAndPassword usernameAndPassword) async {
    try {
      final token = await authDataSource.login(
          username: usernameAndPassword.username,
          password: usernameAndPassword.password);
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, User>> signup(
      UsernameAndPassword usernameAndPassword) async {
    try {
      final user = await authDataSource.signup(
          username: usernameAndPassword.username,
          password: usernameAndPassword.password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
}
