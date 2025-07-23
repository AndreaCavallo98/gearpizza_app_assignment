import 'package:bloc/bloc.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  final GearPizzaDirectusApiService service;

  RestaurantsCubit(this.service) : super(RestaurantsInitial()) {
    print('[Cubit] RestaurantsCubit constructor called');
    fetchRestaurants(); // ✅ chiamata diretta all'inizio
  }

  Future<void> fetchRestaurants() async {
    print('[Cubit] fetchRestaurants called'); // ✅
    emit(RestaurantsLoading());
    try {
      final items = await service.getRestaurants();
      //items.add(items[0]);
      //items.add(items[0]);
      //items.add(items[0]);
      print('[Cubit] items: $items'); // 👈 AGGIUNGI QUESTA
      emit(RestaurantsLoaded(items));
    } on GearPizzaAppException catch (e) {
      print('[Cubit] AppException: ${e.message}');
      emit(RestaurantsError(e.message));
    } catch (e, s) {
      print('[Cubit] Unexpected error: $e');
      print('[Cubit] STACKTRACE: $s'); // 👈 AGGIUNGI QUESTA
      emit(RestaurantsError('Errore inatteso: $e'));
    }
  }
}
