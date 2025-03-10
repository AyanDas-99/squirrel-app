part of 'remove_item_bloc.dart';

sealed class RemoveItemState extends Equatable {
  const RemoveItemState();
  
  @override
  List<Object> get props => [];
}

final class RemoveItemInitial extends RemoveItemState {}
final class RemoveItemLoading extends RemoveItemState {}
final class RemoveItemError extends RemoveItemState {
  final String message;

  const RemoveItemError({required this.message});
}
final class ItemRemoved extends RemoveItemState {}
