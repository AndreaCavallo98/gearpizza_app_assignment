import 'package:bloc/bloc.dart';
import 'package:gearpizza/core/error/gearpizza_app_exception.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/orders/logic/orders_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GearPizzaDirectusApiService service;

  OrdersCubit(this.service) : super(OrdersInitial()) {
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    emit(OrdersLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? customerId = prefs.getInt('customer_id');
      if (customerId == null) {
        emit(OrdersLoaded([]));
        return;
      }
      final items = await service.getCustomerOrders(customerId);
      emit(OrdersLoaded(items));
    } on GearPizzaAppException catch (e) {
      emit(OrdersError(e.message));
    } catch (e) {
      emit(OrdersError('Errore inatteso: $e'));
    }
  }
}
