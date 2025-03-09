import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String password;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const User({required this.id, required this.username, required this.password, required this.isAdmin, required this.createdAt, required this.updatedAt, required this.version});
  
  @override
  List<Object?> get props => [id, username, password, isAdmin, createdAt, updatedAt, version];
}