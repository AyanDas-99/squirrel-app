part of 'add_tag_for_item_bloc.dart';

sealed class AddTagForItemEvent extends Equatable {
  const AddTagForItemEvent();

  @override
  List<Object> get props => [];
}

class EventAddTagForItem extends AddTagForItemEvent {
  final AuthToken token;
  final int itemId;
  final int tagId;

  const EventAddTagForItem({
    required this.token,
    required this.itemId,
    required this.tagId,
  });
}
