import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class IssueModel extends Issue {
  IssueModel({
    required super.id,
    required super.itemId,
    required super.quantity,
    required super.issuedTo,
    required super.issuedAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      quantity: json['quantity'] as int,
      issuedTo: json['issued_to'] as String,
      issuedAt: DateTime.parse(json['issued_at']),
    );
  }
}
