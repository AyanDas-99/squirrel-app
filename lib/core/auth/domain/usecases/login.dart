import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';

class Login implements Usecase<Tokenparam<User>, UsernameAndPassword> {
  final UserRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, Tokenparam<User>>> call(
      UsernameAndPassword usernameAndPassword) async {
    return await repository.login(usernameAndPassword);
  }
}
