import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> getAllTransactions(Tokenparam<ItemIdAndTransactionFilter> tokenItemAndFilter);
  Future<Either<Failure, Issue>> issueItem(Tokenparam<IssueParam> tokenAndIssueParam);
}

class IssueParam {
  final int itemId;
  final int quantity;
  final String issuedTo;

  IssueParam({required this.itemId, required this.quantity, required this.issuedTo});
}