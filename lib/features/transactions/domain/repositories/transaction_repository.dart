import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> getAllTransactions(Tokenparam<int> tokenParamItemId);
}