import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/users/domain/repositories/users_repository.dart';

class UpdatePermission
    implements Usecase<bool, Tokenparam<UpdatePermissionParam>> {
  final UsersRepository repository;

  UpdatePermission(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    Tokenparam<UpdatePermissionParam> tokenAndUpdateParam,
  ) async {
    return await repository.updatePermission(
      token: tokenAndUpdateParam.token,
      userId: tokenAndUpdateParam.param.userId,
      permissionId: tokenAndUpdateParam.param.permissionId,
      grant: tokenAndUpdateParam.param.grant,
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
