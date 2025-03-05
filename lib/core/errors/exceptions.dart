class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server Error'});
}

class UserException implements Exception {
  final String message;
  UserException({this.message = 'User Error'});
}
