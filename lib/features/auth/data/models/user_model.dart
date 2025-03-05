import 'package:squirrel_app/features/auth/domain/entities/user.dart';

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
      id: json['id'],
      username: json['username'],
      password: json['password'],
      isAdmin: json['is_admin'] as bool,
      createdAt: json['created_at'] as DateTime,
      updatedAt: json['updated_at'] as DateTime,
      version: json['version'] as int,
    );
  }
}
