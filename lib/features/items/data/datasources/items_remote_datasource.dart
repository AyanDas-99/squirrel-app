import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/metadata.dart';
import 'package:squirrel_app/features/items/data/models/items_model.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';

abstract class ItemRemoteDatasource {
  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<ItemsAndMeta> getItems(AuthToken token, ItemsFilter filter);
}

class ItemRemoteDatasourceImpl implements ItemRemoteDatasource {
  final host = "http://10.0.2.2:8080";

  final http.Client client;

  Map<String, String> getHeader(AuthToken token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.token}',
    };
  }

  ItemRemoteDatasourceImpl({required this.client});
  @override
  Future<ItemsAndMeta> getItems(AuthToken token, ItemsFilter filter) async {
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/items?${filter.toQuery()}'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final List<ItemModel> items =
          (json.decode(result.body)['items']).map<ItemModel>((item) {
            return ItemModel.fromJson(item);
          }).toList();

      final Metadata metaData = Metadata.fromJson(
        json.decode(result.body)['metadata'],
      );
      return ItemsAndMeta(items: items, meta: metaData);
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 422) {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
    } else {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
    }
  }
}
