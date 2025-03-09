import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';

class Tokenparam<A> {
  final AuthTokenModel token;
  final A param;

  Tokenparam({required this.token, required this.param});
}
