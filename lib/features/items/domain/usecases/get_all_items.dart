import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class GetAllItems implements Usecase<ItemsAndMeta, Tokenparam<ItemsFilter>> {
  final ItemsRepositories repository;

  GetAllItems(this.repository);

  @override
  Future<Either<Failure, ItemsAndMeta>> call(Tokenparam<ItemsFilter> tokenparam) async {
    return await repository.getItems(tokenparam.token, tokenparam.param);
  }
}
