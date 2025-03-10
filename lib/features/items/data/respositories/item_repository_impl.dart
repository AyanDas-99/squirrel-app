import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/items/data/datasources/items_remote_datasource.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class ItemRepositoryImpl implements ItemsRepositories {
  final ItemRemoteDatasource itemRemoteDatasource;

  ItemRepositoryImpl({required this.itemRemoteDatasource});
  @override
  Future<Either<Failure, ItemsAndMeta>> getItems(
    AuthToken token,
    ItemsFilter filter,
  ) async {
    try {
      final itemsAndMeta = await itemRemoteDatasource.getItems(token, filter);
      return Right(itemsAndMeta);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, Item>> addItem({
    required AuthToken token,
    required String name,
    required int quantity,
    required String remarks,
  }) async {
    try {
      final item = await itemRemoteDatasource.addItem(
        token,
        name,
        quantity,
        remarks,
      );
      return Right(item);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
  
  @override
  Future<Either<Failure, bool>> removeItem(AuthToken token, int itemId) async{
    try {
      final isRemoved = await itemRemoteDatasource.removeItem(token, itemId);
      return Right(isRemoved);
    }  on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }

  }
}
