import 'package:squirrel_app/core/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.password,
    required super.isAdmin,
    required super.createdAt,
    required super.updatedAt,
    required super.version,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'],
      password: json['password'],
      isAdmin: json['is_admin'] as bool,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      version: json['version'] as int,
    );
  }
}
