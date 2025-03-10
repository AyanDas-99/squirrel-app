import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';

abstract class ItemsRepositories {
  Future<Either<Failure, ItemsAndMeta>> getItems(
    AuthToken token,
    ItemsFilter filter,
  );

  Future<Either<Failure, bool>> removeItem(AuthToken token, int itemId);

  Future<Either<Failure, Item>> addItem({
    required AuthToken token,
    required String name,
    required int quantity,
    required String remarks,
  });
}

class ItemParams {
  final String name;
  final int quantity;
  final String? remarks;

  ItemParams({
    required this.name,
    required this.quantity,
    required this.remarks,
  });
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
