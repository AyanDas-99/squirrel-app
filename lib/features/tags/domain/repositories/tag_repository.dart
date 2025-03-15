import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';

abstract class TagRepository {
  Future<Either<Failure, List<Tag>>> getAllTags(AuthToken authToken);
  Future<Either<Failure, List<Tag>>> getAllTagsForItem(
    AuthToken authToken,
    int itemId,
  );
  Future<Either<Failure, bool>> removeTag(AuthToken authToken, int tagId);
  Future<Either<Failure, Tag>> addTag(AuthToken authToken, String tag);
  Future<Either<Failure, bool>> addTagForItem({
    required AuthToken authToken,
    required int itemId,
    required int tagId,
  });
  Future<Either<Failure, bool>> removeTagForItem({
    required AuthToken authToken,
    required int itemId,
    required int tagId,
  });
}
