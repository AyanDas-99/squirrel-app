part of 'add_item_bloc.dart';

sealed class AddItemEvent extends Equatable {
  const AddItemEvent();

  @override
  List<Object> get props => [];
}

class EventAddItem extends AddItemEvent {
  final AuthToken token;
  final String name;
  final int quantity;
  final String? remarks;

  const EventAddItem({
    required this.token,
    required this.name,
    required this.quantity,
    required this.remarks,
  });
}
