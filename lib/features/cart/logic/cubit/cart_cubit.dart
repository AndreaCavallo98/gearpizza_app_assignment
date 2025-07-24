import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/cart/models/cart_item.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'cart_state.dart';
import 'package:gearpizza/features/restaurants/models/pizza.dart';

class CartCubit extends HydratedCubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Pizza pizza, int? restaurantId) {
    // Se il carrello ha un ristorante diverso, non aggiungere nulla
    if (state.restaurantId != null && state.restaurantId != restaurantId) {
      return;
    }

    final index = state.items.indexWhere((item) => item.pizza.id == pizza.id);

    if (index == -1) {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            CartItem(pizza: pizza, quantity: 1),
          ],
          restaurantId: state.restaurantId ?? restaurantId,
        ),
      );
    } else {
      final updatedItems = List<CartItem>.from(state.items);
      final existing = updatedItems[index];
      updatedItems[index] = CartItem(
        pizza: existing.pizza,
        quantity: existing.quantity + 1,
      );
      emit(state.copyWith(items: updatedItems));
    }
  }

  void decrementQuantity(Pizza pizza) {
    final index = state.items.indexWhere((item) => item.pizza.id == pizza.id);
    if (index == -1) return;

    final updatedItems = List<CartItem>.from(state.items);
    final existing = updatedItems[index];

    if (existing.quantity <= 1) {
      // Rimuovi se la quantità diventerebbe 0
      updatedItems.removeAt(index);
    } else {
      updatedItems[index] = CartItem(
        pizza: existing.pizza,
        quantity: existing.quantity - 1,
      );
    }

    emit(state.copyWith(items: updatedItems));
  }

  void removeFromCart(Pizza pizza) {
    emit(
      state.copyWith(
        items: state.items.where((item) => item.pizza.id != pizza.id).toList(),
      ),
    );
  }

  void clearCart() {
    emit(const CartState());
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    try {
      final data = {'items': state.items.map((item) => item.toJson()).toList()};
      print('🟢 Saving cart state: $data');
      return data;
    } catch (e) {
      print('🔴 Error serializing cart: $e');
      return null;
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      print('🟢 Restoring cart state: $json');
      final itemsJson = json['items'] as List<dynamic>? ?? [];
      return CartState(
        items: itemsJson
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('🔴 Error deserializing cart: $e');
      return const CartState();
    }
  }
}
