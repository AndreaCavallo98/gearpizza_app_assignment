// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pizza _$PizzaFromJson(Map<String, dynamic> json) => Pizza(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  allergens: (json['allergens'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$PizzaToJson(Pizza instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'allergens': instance.allergens,
};
