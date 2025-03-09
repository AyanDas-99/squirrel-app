part of 'item_bloc.dart';

sealed class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

final class ItemsInitial extends ItemState {}

final class ItemsLoading extends ItemState {}

final class ItemsError extends ItemState {
  final String message;

  const ItemsError({required this.message});
}

final class ItemsLoaded extends ItemState {
  final ItemsAndMeta itemsAndMeta;
  const ItemsLoaded({required this.itemsAndMeta});
}
