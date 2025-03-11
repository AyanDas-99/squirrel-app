part of 'item_refill_bloc.dart';

sealed class ItemRefillState extends Equatable {
  const ItemRefillState();

  @override
  List<Object> get props => [];
}

final class ItemRefillInitial extends ItemRefillState {}

final class ItemRefillLoading extends ItemRefillState {}

final class ItemRefillError extends ItemRefillState {
  final String message;

  const ItemRefillError({required this.message});
}

final class ItemRefilled extends ItemRefillState {
  final Addition addition;

  const ItemRefilled({required this.addition});
}
