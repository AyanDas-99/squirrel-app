import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class GetItemById implements Usecase<Item, Tokenparam<int>> {
  final ItemsRepositories repository;

  GetItemById(this.repository);

  @override
  Future<Either<Failure, Item>> call(Tokenparam<int> tokenparam) async {
    return await repository.getItemById(tokenparam.token, tokenparam.param);
  }
}