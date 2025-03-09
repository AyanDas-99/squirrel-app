import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/auth/data/datasources/auth_data_source.dart';
import 'package:squirrel_app/core/auth/data/datasources/auth_local_data_source.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';
import 'package:squirrel_app/core/tokenParam.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthDataSource authDataSource;
  final AuthLocalDataSource authLocalDataSource;

  UserRepositoryImpl({
    required this.authDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, Tokenparam<User>>> login(
    UsernameAndPassword usernameAndPassword,
  ) async {
    try {
      final tokenAndUser = await authDataSource.login(
        username: usernameAndPassword.username,
        password: usernameAndPassword.password,
      );
      authLocalDataSource.cacheAuthToken(tokenAndUser.token);
      return Right(tokenAndUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, User>> signup(
    UsernameAndPassword usernameAndPassword,
  ) async {
    try {
      final user = await authDataSource.signup(
        username: usernameAndPassword.username,
        password: usernameAndPassword.password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> getLocalToken() async {
    try {
      final token = await authLocalDataSource.getAuthToken();
      return Right(token);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> validateToken(AuthToken authToken) async {
    try {
      final user = await authDataSource.validateToken(authToken);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final isRemoved = await authLocalDataSource.removeAuthToken();
      return Right(isRemoved);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
