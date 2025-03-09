import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final List? properties;

  const Failure({required this.properties});

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {
  const ServerFailure({super.properties});
}

class UserFailure extends Failure {
  const UserFailure({super.properties});
}

class CacheFailure extends Failure {
  const CacheFailure({super.properties});
}

class AdditionFailure extends Failure {
  const AdditionFailure({required super.properties});
}

class RemovalFailure extends Failure {
  const RemovalFailure({required super.properties});
}
class IssuesFailure extends Failure {
  const IssuesFailure({required super.properties});
}