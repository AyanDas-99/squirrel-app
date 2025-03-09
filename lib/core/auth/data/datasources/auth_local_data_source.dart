import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  // Throws [CacheException] if no cached data is present
  Future<AuthTokenModel> getAuthToken();
  // Throws [CacheException] if caching fails
  Future<void> cacheAuthToken(AuthTokenModel token);
  // Throws [CacheException] if caching fails
  Future<bool> removeAuthToken();
}

const CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AuthTokenModel> getAuthToken() async {
    final tokenString = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (tokenString == null) {
      throw CacheException();
    } else {
      return Future.value(AuthTokenModel.fromJson(json.decode(tokenString)));
    }
  }

  @override
  Future<void> cacheAuthToken(AuthTokenModel token) {
    return sharedPreferences.setString(
      CACHED_AUTH_TOKEN,
      json.encode(token.toJson()),
    );
  }

  @override
  Future<bool> removeAuthToken() {
    return sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }
}
