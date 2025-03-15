import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/errors/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getAllUsers(AuthToken token);
  Future<Either<Failure, bool>> updatePermission({
    required AuthToken token,
    required int userId,
    required int permissionId,
    required bool grant,
  });
  Future<Either<Failure, List<String>>> getAllPermissions(
    AuthToken token,
    int userId,
  );
}
