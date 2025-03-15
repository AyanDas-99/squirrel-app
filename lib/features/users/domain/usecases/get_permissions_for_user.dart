import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/users/domain/repositories/users_repository.dart';

class GetPermissionsForUser implements Usecase<List<String>, Tokenparam<int>> {
  final UsersRepository repository;

  GetPermissionsForUser(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    Tokenparam<int> tokenAndUserId,
  ) async {
    return await repository.getAllPermissions(
      tokenAndUserId.token,
      tokenAndUserId.param,
    );
  }
}

class UpdatePermissionParam {
  final int userId;
  final int permissionId;
  final bool grant;

  UpdatePermissionParam({
    required this.userId,
    required this.permissionId,
    required this.grant,
  });
}
