import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:squirrel_app/core/auth/data/models/user_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/domain/entities/user.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/host.dart';

abstract class UsersDatasource {
  // Throws exception [UserException] or [ServerException]
  Future<List<User>> getAllUsers(AuthToken token);
  // Throws exception [UserException] or [ServerException]
  Future<bool> updatePermission({
    required AuthToken token,
    required int userId,
    required int permissionId,
    required bool grant,
  });
  // Throws exception [UserException] or [ServerException]
  Future<List<String>> getAllPermissionsForUser(AuthToken token, int userId);
}

class UsersDatasourceImpl extends UsersDatasource {

  final http.Client client;
  UsersDatasourceImpl({required this.client});

  Map<String, String> getHeader(AuthToken token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.token}',
    };
  }

  @override
  Future<List<User>> getAllUsers(AuthToken token) async {
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/users'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final List<User> users =
          (json.decode(result.body)['users'] == null)
              ? []
              : (json.decode(result.body)['users']).map<UserModel>((user) {
                return UserModel.fromJson(user);
              }).toList();

      return users;
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
  Future<bool> updatePermission({
    required AuthToken token,
    required int userId,
    required int permissionId,
    required bool grant,
  }) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/users/permissions'),
        headers: getHeader(token),
        body: json.encode({
          "user_id": userId,
          "permission_id": permissionId,
          "grant": grant,
        }),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 201) {
      return true;
    } else if (result.statusCode == 500) {
      throw ServerException(message: json.decode(result.body)['error']);
    } else if (result.statusCode == 400) {
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
  Future<List<String>> getAllPermissionsForUser(AuthToken token, int userId) async{
    http.Response result;
    try {
      result = await client.get(
        Uri.parse('$host/users/permissions/$userId'),
        headers: getHeader(token),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      final List<String> users =
          (json.decode(result.body)['permissions'] == null)
              ? []
              : (json.decode(result.body)['permissions']).map<String>((permission) {
                return (permission as String);
              }).toList();

      return users;
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
}
