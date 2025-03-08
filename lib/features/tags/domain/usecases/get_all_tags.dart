import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class GetAllTags extends Usecase<List<Tag>, AuthToken> {
  final TagRepository repository;

  GetAllTags({required this.repository});
  @override
  Future<Either<Failure, List<Tag>>> call(AuthToken token) {
    return repository.getAllTags(token);
  }
}
