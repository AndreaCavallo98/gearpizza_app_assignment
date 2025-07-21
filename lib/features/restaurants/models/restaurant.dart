import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final String id;
  final String name;

  @JsonKey(name: 'cover_image')
  final String? coverImageId;

  final List<int> pizzas;

  Restaurant({
    required this.id,
    required this.name,
    this.coverImageId,
    required this.pizzas,
  });

  String get coverImageUrl => 'https://gearpizza.revod.services/assets/$coverImageId';
  int get totalPizzas => pizzas.length;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
