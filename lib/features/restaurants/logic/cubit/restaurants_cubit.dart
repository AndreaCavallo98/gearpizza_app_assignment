import 'package:bloc/bloc.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  final GearPizzaDirectusApiService service;

  RestaurantsCubit(this.service) : super(RestaurantsInitial());

  Future<void> fetchRestaurants() async {
    emit(RestaurantsLoading());
    try {
      final items = await service.getRestaurants();
      emit(RestaurantsLoaded(items));
    } on GearPizzaAppException catch (e) {
      emit(RestaurantsError(e.message));
    } catch (e) {
      emit(RestaurantsError('Errore inatteso: $e'));
    }
  }
}