part of 'remove_tag_for_item_bloc.dart';

sealed class RemoveTagForItemDartState extends Equatable {
  const RemoveTagForItemDartState();
  
  @override
  List<Object> get props => [];
}

final class RemoveTagForItemDartInitial extends RemoveTagForItemDartState {}
final class RemoveTagForItemDartLoading extends RemoveTagForItemDartState {}
final class RemoveTagForItemDartError extends RemoveTagForItemDartState {
  final String message;

  const RemoveTagForItemDartError({required this.message});
}
final class TagRemoved extends RemoveTagForItemDartState {}
