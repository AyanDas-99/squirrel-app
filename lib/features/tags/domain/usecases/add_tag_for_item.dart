import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class AddTagForItem extends Usecase<bool, Tokenparam<ItemTagParam>> {
  final TagRepository repository;

  AddTagForItem({required this.repository});
  @override
  Future<Either<Failure, bool>> call(Tokenparam<ItemTagParam> tokenParam) {
    return repository.addTagForItem(
      authToken: tokenParam.token,
      itemId: tokenParam.param.itemId,
      tagId: tokenParam.param.tagId,
    );
  }
}

class ItemTagParam {
  final int itemId;
  final int tagId;

  ItemTagParam({required this.itemId, required this.tagId});
}
