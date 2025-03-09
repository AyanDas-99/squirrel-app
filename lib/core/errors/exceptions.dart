class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server Error'});
}

class UserException implements Exception {
  final String message;
  UserException({this.message = 'User Error'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Exception'});
}

class AdditionsException implements Exception {
  final String message;

  AdditionsException({required this.message});
}

class RemovalsException implements Exception {
  final String message;

  RemovalsException({required this.message});
}

class IssuesException implements Exception {
  final String message;

  IssuesException({required this.message});
}
