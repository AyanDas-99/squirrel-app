// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:squirrel_app/core/metadata.dart';
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class Transaction {
  final List<Addition> additions;
  final List<Removal> removals;
  final List<Issue> issues;
  final Metadata metadata;

  Transaction({
    required this.additions,
    required this.removals,
    required this.issues,
    required this.metadata,
  });

  List<Event> getSortedList() {
    final List<Event> list = [...additions, ...removals, ...issues];
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }
}

class TransactionFilter {
  int page;
  int? pageSize;
  TransactionFilter({required this.page, this.pageSize});

  String toQuery() {
    final query = <String, dynamic>{};
    query['page'] = page;
    if (pageSize != null) {
      query['page_size'] = pageSize;
    }
    return query.entries.map((e) => '${e.key}=${e.value}').join('&');
  }
}

class ItemIdAndTransactionFilter {
  final int itemId;
  final TransactionFilter transactionFilter;

  ItemIdAndTransactionFilter({
    required this.itemId,
    required this.transactionFilter,
  });
}
