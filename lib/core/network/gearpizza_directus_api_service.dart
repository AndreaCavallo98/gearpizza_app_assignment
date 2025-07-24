import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gearpizza/core/network/dio_client.dart';
import 'package:gearpizza/features/cart/models/cart_item.dart';
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

  //
  // => Qua ci andrebbe una TRANSAZIONE e in caso di errore di una ROLLBACK (per semplicità non si è effettuata)
  //
  Future<Map<String, dynamic>> submitOrder({
    required String name,
    required String email,
    required String address,
    required File imageFile,
    required List<CartItem> cartItems,
    required int restaurantId,
  }) async {
    print("name: $name");
    print("email: $email");
    print("address: $address");
    print("image: ${imageFile.path}");
    print("cartItems: ${cartItems.toString()}");
    // STEP 1: Crea cliente se non esiste
    print("PRE GET CUSTOMER");
    final customerRes = await _dio.get(
      '/items/customers',
      queryParameters: {
        'filter': {
          'email_address': {'_eq': email},
          'restaurant': restaurantId,
        },
        'fields': 'id,email_address',
      },
    );
    print("EXISTS? ${customerRes.data['data']}");

    int customerId;
    bool customerAlreadyExists = false;

    if ((customerRes.data['data'] as List).isEmpty) {
      // Crea nuovo cliente
      print("PRE POST CUSTOMER");
      final newCustomer = await _dio.post(
        '/items/customers',
        data: {
          'name': name,
          'email_address': email,
          'restaurant': restaurantId,
        },
      );
      customerId = newCustomer.data['data']['id'];
      customerAlreadyExists = false;
    } else {
      customerId = customerRes.data['data'][0]['id'];
      customerAlreadyExists = true;
    }

    print("PRE UPLOAD");
    // STEP 2: Upload immagine
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });

    final imageUploadRes = await _dio.post('/files', data: formData);
    final imageId = imageUploadRes.data['data']['id'];
    print("PRE CREATE ORDER");
    // STEP 3: Crea ordine
    /*final orderRes = await _dio.post(
      '/items/orders',
      data: {
        'status': 'pending',
        'restaurant': restaurantId,
        'customer': customerId,
        'address': address,
        'helping_image': imageId,
        //'pizzas': cartItems.map((item) => item.pizza.id).toList(),
      },
    );*/
    // STEP 3: Crea ordine con associazione pizze
    final orderRes = await _dio.post(
      '/items/orders',
      data: {
        'status': 'pending',
        'restaurant': restaurantId,
        'customer': customerId,
        'address': address,
        'helping_image': imageId,
        'pizzas': {
          'create': cartItems.map((item) {
            return {
              'orders_id': '+',
              'pizzas_id': {'id': item.pizza.id},
            };
          }).toList(),
        },
      },
    );

    return {
      'orderId': orderRes.data['data']['id'],
      'customerAlreadyExists': customerAlreadyExists,
    };
  }
}
