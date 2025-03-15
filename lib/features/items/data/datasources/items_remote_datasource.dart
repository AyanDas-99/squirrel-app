import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/metadata.dart';
import 'package:squirrel_app/features/items/data/models/items_model.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';
import 'package:squirrel_app/features/items/domain/entities/items_and_meta.dart';
import 'package:squirrel_app/features/items/domain/repositories/items_repositories.dart';
import 'package:squirrel_app/features/transactions/data/models/addition_model.dart';
import 'package:squirrel_app/features/transactions/data/models/removal_model.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

abstract class ItemRemoteDatasource {
  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<ItemsAndMeta> getItems(AuthToken token, ItemsFilter filter);

  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<Item> addItem(
    AuthToken token,
    String name,
    int quantity,
    String remarks,
  );

  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<bool> removeItem(AuthToken token, int itemId);

  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<Addition> refillItem(
    AuthToken token,
    int itemId,
    int quantity,
    String remarks,
  );

  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<Item> getItemById(AuthToken token, int itemId);



  /// Throws [ServerException] if an error occurs.
  /// Throws [UserException] if the user is not authenticated.
  Future<Removal> addRemoval(
    AuthToken token,
    int itemId,
    int quantity,
    String remarks,
  );

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

  @override
  Future<Item> addItem(
    AuthToken token,
    String name,
    int quantity,
    String remarks,
  ) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/items'),
        headers: getHeader(token),
        body: json.encode({
          'name': name,
          'quantity': quantity,
          'remarks': remarks,
        }),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 201) {
      final item = ItemModel.fromJson(json.decode(result.body)['item']);
      return item;
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

  @override
  Future<bool> removeItem(AuthToken token, int itemId) async {
    http.Response result;
    try {
      result = await client.delete(
        Uri.parse('$host/items/$itemId'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      return true;
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 404) {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
    } else {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
    }
  }

  @override
  Future<Addition> refillItem(
    AuthToken token,
    int itemId,
    int quantity,
    String remarks,
  ) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/additions'),
        headers: getHeader(token),
        body: json.encode({
          'item_id': itemId,
          'quantity': quantity,
          'remarks': remarks,
        }),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final addition = AdditionModel.fromJson(
        json.decode(result.body)['addition'],
      );
      return addition;
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 404) {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
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

  @override
  Future<Item> getItemById(AuthToken token, int itemId) async {
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/items/$itemId'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final item = ItemModel.fromJson(
        json.decode(result.body)['item'],
      );
      return item;
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 404) {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
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
  
  @override
  Future<Removal> addRemoval(AuthToken token, int itemId, int quantity, String remarks) async{
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/removals'),
        headers: getHeader(token),
        body: json.encode({
          'item_id': itemId,
          'quantity': quantity,
          'remarks': remarks,
        }),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 201) {
      final removal = RemovalModel.fromJson(
        json.decode(result.body)['removal'],
      );
      return removal;
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 404) {
      throw UserException(
        message: json.decode(result.body)['error'].toString(),
      );
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
