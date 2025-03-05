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