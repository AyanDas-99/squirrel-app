part of 'add_item_bloc.dart';

sealed class AddItemState extends Equatable {
  const AddItemState();

  @override
  List<Object> get props => [];
}

final class AddItemInitial extends AddItemState {}

final class AddItemLoading extends AddItemState {}

final class AddItemError extends AddItemState {
  final String error;
  const AddItemError({required this.error});
}

final class AddItemLoaded extends AddItemState {
  final Item item;
  const AddItemLoaded({required this.item});
}
