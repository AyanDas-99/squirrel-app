import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class AddTag extends Usecase<Tag, Tokenparam<String>> {
  final TagRepository repository;

  AddTag({required this.repository});
  @override
  Future<Either<Failure, Tag>> call(Tokenparam<String> tokenParamString) {
    return repository.addTag(tokenParamString.token, tokenParamString.param);
  }
}
