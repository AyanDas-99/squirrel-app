import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';
import 'package:squirrel_app/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource transactionRemoteDatasource;

  TransactionRepositoryImpl({required this.transactionRemoteDatasource});
  @override
  Future<Either<Failure, Transaction>> getAllTransactions(
    Tokenparam<ItemIdAndTransactionFilter> tokenItemAndFilter,
  ) async {
    try {
      final transaction = await transactionRemoteDatasource.getAllTransactions(
        tokenItemAndFilter,
      );
      return Right(transaction);
    } on AdditionsException catch (e) {
      return Left(AdditionFailure(properties: [e.message]));
    } on RemovalsException catch (e) {
      return Left(RemovalFailure(properties: [e.message]));
    } on IssuesException catch (e) {
      return Left(IssuesFailure(properties: [e.message]));
    }
  }

  @override
  Future<Either<Failure, Issue>> issueItem(
    Tokenparam<IssueParam> tokenAndIssueParam,
  ) async {
    try {
      final issue = await transactionRemoteDatasource.issueItem(
        token: tokenAndIssueParam.token,
        itemId: tokenAndIssueParam.param.itemId,
        quantity: tokenAndIssueParam.param.quantity,
        issueTo: tokenAndIssueParam.param.issuedTo,
      );
      return Right(issue);
    } on ServerException catch (e) {
      return Left(ServerFailure(properties: [e.message]));
    } on UserException catch (e) {
      return Left(UserFailure(properties: [e.message]));
    }
  }
}
