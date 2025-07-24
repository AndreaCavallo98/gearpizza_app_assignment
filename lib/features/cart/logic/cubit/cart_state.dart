import 'package:gearpizza/features/cart/models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final int? restaurantId;

  const CartState({this.items = const [], this.restaurantId});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.quantity * 10));

  CartState copyWith({List<CartItem>? items, int? restaurantId}) {
    return CartState(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }
}
