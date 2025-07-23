import 'package:json_annotation/json_annotation.dart';

part 'allergen.g.dart';

@JsonSerializable()
class Allergen {
  final int id;
  final String name;

  Allergen({required this.id, required this.name});

  factory Allergen.fromJson(Map<String, dynamic> json) =>
      _$AllergenFromJson(json);

  Map<String, dynamic> toJson() => _$AllergenToJson(this);
}
