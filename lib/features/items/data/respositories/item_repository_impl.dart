import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/items/data/datasources/items_remote_datasource.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

class ItemRepositoryImpl implements ItemsRepositories {
  final ItemRemoteDatasource itemRemoteDatasource;

  ItemRepositoryImpl({required this.itemRemoteDatasource});
  @override
  Future<Either<Failure, ItemsAndMeta>> getItems(AuthToken token, ItemsFilter filter) async {
    try {
      final itemsAndMeta = await itemRemoteDatasource.getItems(token, filter);
      return Right(itemsAndMeta);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
}
