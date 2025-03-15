import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/users/domain/repositories/users_repository.dart';

class GetAllUsers implements Usecase<List<User>, AuthToken> {
  final UsersRepository repository;

  GetAllUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(
      AuthToken token) async {
    return await repository.getAllUsers(token);
  }
}
