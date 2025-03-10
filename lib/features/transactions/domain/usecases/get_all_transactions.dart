import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';
import 'package:squirrel_app/features/transactions/domain/repositories/transaction_repository.dart';

class GetAllTransactions extends Usecase<Transaction, Tokenparam<ItemIdAndTransactionFilter>> {
  final TransactionRepository repository;

  GetAllTransactions({required this.repository});
  @override
  Future<Either<Failure, Transaction>> call(Tokenparam<ItemIdAndTransactionFilter> params) {
    return repository.getAllTransactions(params);
  }
}
