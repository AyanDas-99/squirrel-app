import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';

class Signup implements Usecase<User, UsernameAndPassword> {

  final UserRepository repository;

  Signup(this.repository);

  @override
  Future<Either<Failure, User>> call(UsernameAndPassword usernameAndPassword) async{
    return await repository.signup(usernameAndPassword);
  }
}
