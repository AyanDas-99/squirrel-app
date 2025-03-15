import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/users/data/datasources/users_datasource.dart';
import 'package:squirrel_app/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersDatasource usersDatasource;

  UsersRepositoryImpl({required this.usersDatasource});

  @override
  Future<Either<Failure, List<User>>> getAllUsers(AuthToken token) async {
    try {
      final users = await usersDatasource.getAllUsers(token);
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePermission({
    required AuthToken token,
    required int userId,
    required int permissionId,
    required bool grant,
  }) async {
    try {
      final isChanged = await usersDatasource.updatePermission(
        token: token,
        userId: userId,
        permissionId: permissionId,
        grant: grant,
      );
      return Right(isChanged);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllPermissions(
    AuthToken token,
    int userId,
  ) async {
    try {
      final perms = await usersDatasource.getAllPermissionsForUser(
        token,
        userId,
      );
      return Right(perms);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
}
