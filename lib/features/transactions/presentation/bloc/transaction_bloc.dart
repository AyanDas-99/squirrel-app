import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/errors/failures.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/domain/entities/transaction.dart';
import 'package:squirrel_app/features/transactions/domain/usecases/get_all_transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetAllTransactions getAllTransactions;

  TransactionBloc({required this.getAllTransactions})
    : super(TransactionInitial()) {
    on<LoadTransaction>(_getAllTransactions);
  }

  _getAllTransactions(
    LoadTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final failureOrTransaction = await getAllTransactions(
      Tokenparam(
        token: AuthTokenModel(
          token: event.token.token,
          expiry: event.token.expiry,
        ),
        param: event.itemID,
      ),
    );

    if (failureOrTransaction.isLeft()) {
      final failure = failureOrTransaction.fold((l) => l, (r) => null)!;
      emit(TransactionError(failure: failure));
    } else {
      final transaction = failureOrTransaction.fold((l) => null, (r) => r)!;
      emit(TransactionLoaded(transaction: transaction));
    }
  }
}
