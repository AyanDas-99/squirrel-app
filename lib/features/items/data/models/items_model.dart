import 'package:squirrel_app/features/items/domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.remaining,
    required super.remarks,
    required super.createdAt,
    required super.version,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      name: json['name'],
      quantity: json['quantity'] as int,
      remaining: json['remaining'] as int,
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']),
      version: json['version'] as int,
    );
  }
}
