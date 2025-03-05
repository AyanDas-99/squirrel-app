import 'package:squirrel_app/features/auth/domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({required super.token, required super.expiry});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
        token: json['token'], expiry: json['expiry'] as DateTime);
  }
}
