import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final String token;
  final DateTime expiry;

  const AuthToken({required this.token, required this.expiry});

  @override
  List<Object?> get props => [token, expiry];
}
