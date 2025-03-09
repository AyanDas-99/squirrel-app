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
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }
}
