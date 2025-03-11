part of 'item_by_id_bloc.dart';

sealed class ItemByIdEvent extends Equatable {
  const ItemByIdEvent();

  @override
  List<Object> get props => [];
}

class LoadItemByIdEvent extends ItemByIdEvent {
  final int itemId;
  final AuthToken token;

  const LoadItemByIdEvent({required this.itemId, required this.token});
}
