import 'package:equatable/equatable.dart';
import 'package:gearpizza/features/restaurants/models/pizza.dart';

abstract class PizzasState extends Equatable {
  const PizzasState();
  @override
  List<Object?> get props => [];
}

class PizzasInitial extends PizzasState {}

class PizzasLoading extends PizzasState {}

class PizzasLoaded extends PizzasState {
  final List<Pizza> pizzas;
  const PizzasLoaded(this.pizzas);
  @override
  List<Object?> get props => [pizzas];
}

class PizzasError extends PizzasState {
  final String message;
  const PizzasError(this.message);
  @override
  List<Object?> get props => [message];
}
