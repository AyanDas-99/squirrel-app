part of 'add_removal_bloc.dart';

sealed class AddRemovalState extends Equatable {
  const AddRemovalState();

  @override
  List<Object> get props => [];
}

final class AddRemovalInitial extends AddRemovalState {}

final class AddRemovalLoading extends AddRemovalState {}

final class AddRemovalError extends AddRemovalState {
  final String message;

  const AddRemovalError({required this.message});
}

final class RemovalAdded extends AddRemovalState {
  final Removal removal;

  const RemovalAdded({required this.removal});
}
