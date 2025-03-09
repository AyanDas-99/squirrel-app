
import 'package:squirrel_app/features/transactions/domain/entities/event.dart';

class AdditionModel extends Addition {
  AdditionModel({
    required super.id,
    required super.itemId,
    required super.quantity,
    required super.remarks,
    required super.addedAt,
  });

  factory AdditionModel.fromJson(Map<String, dynamic> json) {
    return AdditionModel(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      quantity: json['quantity'] as int,
      remarks: json['remarks'] as String,
      addedAt: DateTime.parse(json['added_at']),
    );
  }
}
