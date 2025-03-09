import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/repositories/user_repository.dart';

class GetLocalToken implements Usecase<AuthToken, NoParams> {
  final UserRepository repository;

  GetLocalToken(this.repository);

  @override
  Future<Either<Failure, AuthToken>> call(
      NoParams noParam) async {
    return await repository.getLocalToken();
  }
}


