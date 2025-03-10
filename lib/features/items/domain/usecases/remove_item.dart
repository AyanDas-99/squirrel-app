import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class RemoveItem implements Usecase<bool, Tokenparam<int>> {
  final ItemsRepositories repository;

  RemoveItem(this.repository);

  @override
  Future<Either<Failure, bool>> call(Tokenparam<int> tokenparam) async {
    return await repository.removeItem(tokenparam.token, tokenparam.param);
  }
}