import 'package:gearpizza/features/cart/models/cart_item.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(
    0,
    (sum, item) => sum + (item.quantity * 10),
  ); // assumendo 10€ a pizza

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
