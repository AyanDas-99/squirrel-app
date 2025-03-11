import 'package:dartz/dartz.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/core/usecases/usecase.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/domain/repositories/transaction_repository.dart';

class IssueItem extends Usecase<Issue, Tokenparam<IssueParam>> {
  final TransactionRepository repository;

  IssueItem({required this.repository});
  @override
  Future<Either<Failure, Issue>> call(Tokenparam<IssueParam> tokenAndIssueParam) {
    return repository.issueItem(tokenAndIssueParam);
  }
}
