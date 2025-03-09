import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/tags/data/datastores/tag_remote_datasource.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';
import 'package:squirrel_app/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagRemoteDatasource tagRemoteDatasource;

  TagRepositoryImpl({required this.tagRemoteDatasource});
  @override
  Future<Either<Failure, Tag>> addTag(
    AuthToken authToken,
    String tagName,
  ) async {
    try {
      final tag = await tagRemoteDatasource.addTag(authToken, tagName);
      return Right(tag);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getAllTags(AuthToken authToken) async {
    try {
      final tags = await tagRemoteDatasource.getAllTags(authToken);
      return Right(tags);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, bool>> removeTag(
    AuthToken authToken,
    int tagId,
  ) async {
    try {
      final isRemoved = await tagRemoteDatasource.removeTag(authToken, tagId);
      return Right(isRemoved);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getAllTagsForItem(
    AuthToken authToken,
    int itemId,
  ) async {
    try {
      final tags = await tagRemoteDatasource.getAllTagsForItem(authToken, itemId);
      return Right(tags);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
}
