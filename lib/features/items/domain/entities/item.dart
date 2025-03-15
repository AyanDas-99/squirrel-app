import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int id;
  final String name;
  final int quantity;
  final int remaining;
  final String remarks;
  final DateTime createdAt;
  final int version;

  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.remaining,
    required this.remarks,
    required this.createdAt,
    required this.version,
  });
  
  @override
  List<Object?> get props => [id, name, quantity, remaining, remarks, createdAt, version];
}
