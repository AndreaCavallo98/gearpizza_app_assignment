import 'package:bloc/bloc.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/pizzas_state.dart';

class PizzasCubit extends Cubit<PizzasState> {
  final GearPizzaDirectusApiService service;

  PizzasCubit(this.service) : super(PizzasInitial());

  Future<void> fetchPizzas(int restaurantId, List<int> allergens) async {
    emit(PizzasLoading());
    try {
      final items = await service.getPizzas(restaurantId, allergens);
      emit(PizzasLoaded(items));
    } on GearPizzaAppException catch (e) {
      emit(PizzasError(e.message));
    } catch (e) {
      emit(PizzasError('Errore inatteso: $e'));
    }
  }
}
