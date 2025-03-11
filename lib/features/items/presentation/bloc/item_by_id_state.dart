part of 'item_by_id_bloc.dart';

sealed class ItemByIdState extends Equatable {
  const ItemByIdState();

  @override
  List<Object> get props => [];
}

final class ItemByIdInitial extends ItemByIdState {}

final class ItemByIdLoading extends ItemByIdState {}

final class ItemByIdError extends ItemByIdState {
  final String message;
  const ItemByIdError({required this.message});
}

final class ItemByIdLoaded extends ItemByIdState {
  final Item item;
  const ItemByIdLoaded({required this.item});
}
