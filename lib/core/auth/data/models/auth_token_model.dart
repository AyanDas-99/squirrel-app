import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({required super.token, required super.expiry});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
        token: json['token'], expiry: DateTime.parse(json['expiry']));
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiry': expiry.toIso8601String(),
    };
  }
}
