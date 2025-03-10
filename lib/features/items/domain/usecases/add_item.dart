import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class AddItem implements Usecase<Item, Tokenparam<ItemParams>> {
  final ItemsRepositories repository;

  AddItem(this.repository);

  @override
  Future<Either<Failure, Item>> call(Tokenparam<ItemParams> param) async {
    return await repository.addItem(
      token: param.token,
      name: param.param.name,
      quantity: param.param.quantity,
      remarks: param.param.remarks ?? '',
    );
  }
}
