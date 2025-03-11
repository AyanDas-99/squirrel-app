import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class RefillItem extends Usecase<Addition, Tokenparam<ItemRefillParams>> {
  final ItemsRepositories itemsRepositories;

  RefillItem({required this.itemsRepositories});
  @override
  Future<Either<Failure, Addition>> call(Tokenparam<ItemRefillParams> params) {
    return itemsRepositories.refillItem(
      token: params.token,
      itemId: params.param.itemId,
      quantity: params.param.quantity,
      remarks: params.param.remarks,
    );
  }
}
