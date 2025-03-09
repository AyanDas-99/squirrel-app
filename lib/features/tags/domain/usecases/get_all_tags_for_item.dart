import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class GetAllTagsForItem extends Usecase<List<Tag>, Tokenparam<int>> {
  final TagRepository repository;

  GetAllTagsForItem({required this.repository});
  @override
  Future<Either<Failure, List<Tag>>> call(Tokenparam<int> tokenparamAndItemId) {
    return repository.getAllTagsForItem(
      tokenparamAndItemId.token,
      tokenparamAndItemId.param,
    );
  }
}
