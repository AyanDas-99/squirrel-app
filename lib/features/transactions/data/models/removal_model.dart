import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class RemovalModel extends Removal {
  RemovalModel({
    required super.id,
    required super.itemId,
    required super.quantity,
    required super.remarks,
    required super.removedAt,
  });

  factory RemovalModel.fromJson(Map<String, dynamic> json) {
    return RemovalModel(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      quantity: json['quantity'] as int,
      remarks: json['remarks'],
      removedAt: DateTime.parse(json['removed_at']),
    );
  }
}
