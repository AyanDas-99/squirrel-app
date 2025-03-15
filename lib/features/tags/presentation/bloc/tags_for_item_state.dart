part of 'tags_for_item_bloc.dart';

sealed class TagsForItemState extends Equatable {
  const TagsForItemState();

  @override
  List<Object> get props => [];
}

final class TagsForItemInitial extends TagsForItemState {}

final class TagsForItemLoading extends TagsForItemState {}

final class TagsForItemError extends TagsForItemState {
  final String message;

  const TagsForItemError({required this.message});
}

final class TagsForItemLoaded extends TagsForItemState {
  final List<Tag> tags;

  const TagsForItemLoaded({required this.tags});
}
