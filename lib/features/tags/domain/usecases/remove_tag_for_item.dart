import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';
import 'package:squirrel_app/features/tags/domain/usecases/add_tag_for_item.dart';

class RemoveTagForItem extends Usecase<bool, Tokenparam<ItemTagParam>> {
  final TagRepository repository;

  RemoveTagForItem({required this.repository});
  @override
  Future<Either<Failure, bool>> call(Tokenparam<ItemTagParam> tokenParam) {
    return repository.removeTagForItem(
      authToken: tokenParam.token,
      itemId: tokenParam.param.itemId,
      tagId: tokenParam.param.tagId,
    );
  }
}
