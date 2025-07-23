import 'package:bloc/bloc.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/allergens_state.dart';

class AllergensCubit extends Cubit<AllergensState> {
  final GearPizzaDirectusApiService service;

  AllergensCubit(this.service) : super(AllergensInitial());

  Future<void> fetchAllergens() async {
    emit(AllergensLoading());
    try {
      final items = await service.getAllergens();
      emit(AllergensLoaded(items));
    } on GearPizzaAppException catch (e) {
      emit(AllergensError(e.message));
    } catch (e) {
      emit(AllergensError('Errore inatteso: $e'));
    }
  }
}
