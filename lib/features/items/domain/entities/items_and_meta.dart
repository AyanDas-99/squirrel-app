import 'package:squirrel_app/core/metadata.dart';
import 'package:squirrel_app/features/items/domain/entities/item.dart';

class ItemsAndMeta {
  final List<Item> items;
  final Metadata meta;

  ItemsAndMeta({required this.items, required this.meta});
}
