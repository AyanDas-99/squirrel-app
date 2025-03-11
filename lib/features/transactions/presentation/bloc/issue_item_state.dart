part of 'issue_item_bloc.dart';

sealed class IssueItemState extends Equatable {
  const IssueItemState();

  @override
  List<Object> get props => [];
}

final class IssueItemInitial extends IssueItemState {}

final class IssueItemLoading extends IssueItemState {}

final class IssueItemError extends IssueItemState {
  final String message;

  const IssueItemError({required this.message});
}

final class ItemIssued extends IssueItemState {
  final Issue issue;

  const ItemIssued({required this.issue});
}
