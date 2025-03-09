part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionLoaded extends TransactionState {
  final Transaction transaction;

  const TransactionLoaded({required this.transaction});
}

/// Failure is one of [AdditionFailure], [RemovalFailure] or [IssuesFailure]
final class TransactionError extends TransactionState {
  final Failure failure;
  const TransactionError({required this.failure});
}
