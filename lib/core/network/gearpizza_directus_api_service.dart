import 'package:dio/dio.dart';
import 'package:gearpizza/core/network/dio_client.dart';
import 'package:gearpizza/features/restaurants/models/allergen.dart';
import 'package:gearpizza/features/restaurants/models/pizza.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';

class GearPizzaDirectusApiService {
  final Dio _dio = DioClient().dio;

  Future<List<Restaurant>> getRestaurants() async {
    final response = await _dio.get(
      '/items/restaurants',
      queryParameters: {'fields': '*'},
    );

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => Restaurant.fromJson(json)).toList();
  }

  Future<List<Pizza>> getPizzas(int restaurantId, List<int> allergens) async {
    final Map<String, dynamic> filter = {
      "restaurant": {"_eq": restaurantId},
    };

    if (allergens.isNotEmpty) {
      filter["_or"] = [
        {
          "allergens": {
            "_none": {
              "allergens_id": {
                "id": {"_in": allergens},
              },
            },
          },
        },
        {
          "allergens": {"_null": true},
        },
      ];
    }

    final response = await _dio.get(
      '/items/pizzas',
      queryParameters: {
        'fields':
            'id,name,description,allergens.allergens_id.name,cover_image.id',
        'filter': filter,
      },
    );

    final data = response.data['data'] as List;
    return data.map((json) => Pizza.fromJson(json)).toList();
  }

  Future<List<Allergen>> getAllergens() async {
    final response = await _dio.get(
      '/items/allergens',
      queryParameters: {'fields': 'id,name'},
    );

    final data = response.data['data'] as List;
    return data.map((json) => Allergen.fromJson(json)).toList();
  }
}
