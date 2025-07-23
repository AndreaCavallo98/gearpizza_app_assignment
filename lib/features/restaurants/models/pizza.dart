import 'package:json_annotation/json_annotation.dart';

part 'pizza.g.dart';

@JsonSerializable(explicitToJson: true)
class Pizza {
  final int id;
  final String name;
  final String description;
  final List<int> allergens;

  // coverImageId estratto da cover_image.id
  @JsonKey(ignore: true)
  final String? coverImageId;

  Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.allergens,
    this.coverImageId,
  });

  String get coverImageUrl =>
      'https://gearpizza.revod.services/assets/$coverImageId';

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      allergens:
          (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      coverImageId: json['cover_image'] != null
          ? json['cover_image']['id'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'allergens': allergens,
    'cover_image': coverImageId != null ? {'id': coverImageId} : null,
  };
}
