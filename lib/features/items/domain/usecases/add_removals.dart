import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class AddRemoval implements Usecase<Removal, Tokenparam<RemovalParam>> {
  final ItemsRepositories repository;

  AddRemoval(this.repository);

  @override
  Future<Either<Failure, Removal>> call(Tokenparam<RemovalParam> params) async {
    return await repository.addRemoval(
      token: params.token,
      itemId: params.param.itemId,
      quantity: params.param.quantity,
      remarks: params.param.remarks,
    );
  }
}

class RemovalParam {
  final int itemId;
  final int quantity;
  final String remarks;

  RemovalParam({
    required this.itemId,
    required this.quantity,
    required this.remarks,
  });
}
