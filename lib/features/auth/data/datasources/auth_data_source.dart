import 'dart:convert';

import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/features/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class AuthDataSource {
  /// Throws a [ServerException] or [UserException] for all error codes
  Future<UserModel> signup(
      {required String username, required String password});

  /// Throws a [ServerException] or [UserException] for all error codes
  Future<AuthTokenModel> login(
      {required String username, required String password});
}

class AuthDataSourceImpl implements AuthDataSource {
  final host = "http://192.168.168.30:8080";

  final http.Client client;
  AuthDataSourceImpl({required this.client});

  @override
  Future<AuthTokenModel> login(
      {required String username, required String password}) {
    return _login(username, password);
  }

  @override
  Future<UserModel> signup(
      {required String username, required String password}) {
    return _signup(username, password);
  }

  Future<UserModel> _signup(String username, String password) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/users'),
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      return UserModel.fromJson(json.decode(result.body)['user']);
    } else if (result.statusCode == 500) {
      throw ServerException(message: result.body);
    } else if (result.statusCode == 422) {
      throw UserException(
          message: json.decode(result.body)['error'].toString());
    } else {
      throw UserException(
          message: json.decode(result.body)['error'].toString());
    }
  }

  Future<AuthTokenModel> _login(String username, String password) async {
    http.Response result;
    try {
      result = await client.post(
        Uri.parse('$host/tokens/authentication'),
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    dev.log(result.body.toString());

    if (result.statusCode == 200) {
      return AuthTokenModel.fromJson(json.decode(result.body)['authentication_token']);
    } else if (result.statusCode == 500) {
      throw ServerException(message: result.body);
    } else if (result.statusCode == 422) {
      throw UserException(
          message: json.decode(result.body)['error'].toString());
    } else if (result.statusCode == 401) {
      throw UserException(
          message: json.decode(result.body)['error'].toString());
    } else {
      throw UserException(
          message: json.decode(result.body)['error'].toString());
    }
  }
}
