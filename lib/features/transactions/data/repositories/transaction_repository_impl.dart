import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/exceptions.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/data/datasources/transactions_remote_datasource.dart';
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
}
