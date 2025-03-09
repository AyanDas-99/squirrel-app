import 'package:squirrel_app/features/tags/domain/entities/tag.dart';

class TagModel extends Tag {
  TagModel({required super.tag, required super.id});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(tag: json['name'], id: json['id']);
  }
}
