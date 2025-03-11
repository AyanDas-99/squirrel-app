import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squirrel_app/core/auth/data/models/auth_token_model.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/tokenParam.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';
import 'package:squirrel_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:squirrel_app/features/transactions/domain/usecases/issue_item.dart';

part 'issue_item_event.dart';
part 'issue_item_state.dart';

class IssueItemBloc extends Bloc<IssueItemEvent, IssueItemState> {
  final IssueItem issueItem;

  IssueItemBloc({required this.issueItem}) : super(IssueItemInitial()) {
    on<EventIssueItem>((event, emit) async {
      emit(IssueItemLoading());
      final failureOrIssue = await issueItem(
        Tokenparam(
          token: AuthTokenModel(
            token: event.token.token,
            expiry: event.token.expiry,
          ),
          param: IssueParam(
            itemId: event.itemId,
            quantity: event.quantity,
            issuedTo: event.issuedTo,
          ),
        ),
      );
      failureOrIssue.fold(
        (failure) => emit(
          IssueItemError(
            message:
                failure.properties?.first.toString() ?? "Failed to issue item",
          ),
        ),
        (issue) => emit(ItemIssued(issue: issue)),
      );
    });
  }
}
