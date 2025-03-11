part of 'issue_item_bloc.dart';

sealed class IssueItemEvent extends Equatable {
  const IssueItemEvent();

  @override
  List<Object> get props => [];
}

class EventIssueItem extends IssueItemEvent {
  final int itemId;
  final int quantity;
  final String issuedTo;
  final AuthToken token;

  const EventIssueItem({
    required this.itemId,
    required this.quantity,
    required this.issuedTo,
    required this.token,
  });
}
