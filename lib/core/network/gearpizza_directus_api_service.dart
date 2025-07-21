import 'package:dio/dio.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/dio_client.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';


class GearPizzaDirectusApiService {
  final Dio _dio = DioClient().dio;

  Future<List<Restaurant>> getRestaurants() async {
  try {
    final response = await _dio.get('/items/restaurants', queryParameters: {
      'fields': '*',
    });

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => Restaurant.fromJson(json)).toList();
  } on DioException catch (e) {
    throw GearPizzaAppException(e.message ?? 'Errore di rete');
  } catch (e) {
    throw GearPizzaAppException('Errore generico: $e');
  }
}

}
