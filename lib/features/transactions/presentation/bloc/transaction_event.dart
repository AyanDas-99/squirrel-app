part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransaction extends TransactionEvent {
  final AuthToken token;
  final int itemID;
  final TransactionFilter filter;

  const LoadTransaction({
    required this.token,
    required this.itemID,
    required this.filter,
  });
}
