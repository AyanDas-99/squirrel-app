// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/features/tags/data/models/tag_model.dart';
import 'package:squirrel_app/features/tags/domain/entities/tag.dart';

abstract class TagRemoteDatasource {
  Future<List<Tag>> getAllTags(AuthToken token);

  /// Throws [ServerException] or [UserException]
  Future<Tag> addTag(AuthToken token, String tag);
  Future<bool> removeTag(AuthToken token, int tagID);
  Future<List<Tag>> getAllTagsForItem(AuthToken token, int itemId);
}

class TagRemoteDatasourceImpl implements TagRemoteDatasource {
  final host = "http://10.0.2.2:8080";

  final http.Client client;
  TagRemoteDatasourceImpl({required this.client});

  Map<String, String> getHeader(AuthToken token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.token}',
    };
  }

  @override
  Future<Tag> addTag(AuthToken token, String tag) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/tags'),
        headers: getHeader(token),
        body: json.encode({"name": tag}),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      return TagModel.fromJson(json.decode(result.body)['tag']);
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
  Future<List<Tag>> getAllTags(AuthToken token) async {
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/tags'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final List<TagModel> tags =
          (json.decode(result.body)['tags'] == null)
              ? []
              : (json.decode(result.body)['tags']).map<TagModel>((tag) {
                return TagModel.fromJson(tag);
              }).toList();

      return tags;
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
  Future<bool> removeTag(AuthToken token, int tagID) async {
    http.Response result;
    try {
      result = await client.delete(
        Uri.parse('$host/tags'),
        headers: getHeader(token),
        body: json.encode({"tag_id": tagID}),
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
  Future<List<Tag>> getAllTagsForItem(AuthToken token, int itemId) async {
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/tags/item/$itemId'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final List<TagModel> tags =
          (json.decode(result.body)['tags'] == null)
              ? []
              : (json.decode(result.body)['tags']).map<TagModel>((tag) {
                return TagModel.fromJson(tag);
              }).toList();

      return tags;
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
