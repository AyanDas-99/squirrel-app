import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class RemoveTag extends Usecase<bool, Tokenparam<int>> {
  final TagRepository repository;

  RemoveTag({required this.repository});
  @override
  Future<Either<Failure, bool>> call(Tokenparam<int> tokenParam) {
    return repository.removeTag(tokenParam.token, tokenParam.param);
  }
}
