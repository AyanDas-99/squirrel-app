part of 'add_tag_for_item_bloc.dart';

sealed class AddTagForItemState extends Equatable {
  const AddTagForItemState();

  @override
  List<Object> get props => [];
}

final class AddTagForItemInitial extends AddTagForItemState {}

final class AddTagForItemLoading extends AddTagForItemState {}

final class AddTagForItemError extends AddTagForItemState {
  final String message;

  const AddTagForItemError({required this.message});
}

final class TagAdded extends AddTagForItemState {}
