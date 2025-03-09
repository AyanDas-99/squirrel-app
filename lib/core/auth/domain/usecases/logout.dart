import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';

class Logout implements Usecase<bool, NoParams> {
  final UserRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams noParam) async {
    return await repository.logout();
  }
}
