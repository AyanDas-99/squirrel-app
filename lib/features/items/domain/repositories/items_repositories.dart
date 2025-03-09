import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';

abstract class ItemsRepositories {
  Future<Either<Failure, ItemsAndMeta>> getItems(
    AuthToken token,
    ItemsFilter filter,
  );
}

class ItemsFilter {
  String? name;
  String? remarks;
  int? tagId;
  int page;
  int? pageSize;
  String? sortBy;

  ItemsFilter({
    this.name,
    this.remarks,
    this.tagId,
    required this.page,
    this.pageSize,
    this.sortBy,
  });

  String toQuery() {
    final query = <String, dynamic>{};
    if (name != null) {
      query['name'] = name;
    }
    if (remarks != null) {
      query['remarks'] = remarks;
    }
    if (tagId != null) {
      query['tag_id'] = tagId;
    }
    query['page'] = page;
    if (pageSize != null) {
      query['page_size'] = pageSize;
    }
    if (sortBy != null) {
      query['sort'] = sortBy;
    }
    return query.entries.map((e) => '${e.key}=${e.value}').join('&');
  }
}
