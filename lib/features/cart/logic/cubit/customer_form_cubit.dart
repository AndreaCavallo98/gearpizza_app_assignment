import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/customer_form_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerFormCubit extends Cubit<CustomerFormState> {
  final GearPizzaDirectusApiService service;
  final CartCubit cartCubit;

  CustomerFormCubit({required this.service, required this.cartCubit})
    : super(CustomerFormState.initial());

  Future<void> submitForm({
    required String name,
    required String email,
    required String address,
    required File imageFile,
  }) async {
    emit(state.copyWith(isSubmitting: true, backendErrors: {}));

    try {
      final result = await service.submitOrder(
        name: name,
        email: email,
        address: address,
        imageFile: imageFile,
        cartItems: cartCubit.state.items,
        restaurantId: cartCubit.state.restaurantId!,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          success: true,
          customerAlreadyExists: result['customerAlreadyExists'],
        ),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'customer_id',
        int.parse(result['customerId'].toString()),
      );
      cartCubit.clearCart();
    } on DioException catch (e) {
      print('❌ DioError details: ${e.response?.data}');
      if (e.response?.statusCode == 400 && e.response?.data['errors'] != null) {
        final Map<String, String> backendErrors = {};
        for (var err in e.response!.data['errors']) {
          final field = err['extensions']?['field'];
          final message = err['message'];
          if (field != null && message != null) {
            backendErrors[field] = message;
          }
        }
        emit(state.copyWith(isSubmitting: false, backendErrors: backendErrors));
      } else {
        emit(
          state.copyWith(
            isSubmitting: false,
            genericError: e.message ?? 'Errore generico. Riprova.',
          ),
        );
      }
    } catch (e) {
      print("🔴🔴🔴 erroreee:" + e.toString());
      emit(
        state.copyWith(
          isSubmitting: false,
          genericError: 'Errore inaspettato: ${e.toString()}',
        ),
      );
    }
  }
}
