import 'package:equatable/equatable.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';

abstract class RestaurantsState extends Equatable {
  const RestaurantsState();
  @override
  List<Object?> get props => [];
}

class RestaurantsInitial extends RestaurantsState {}
class RestaurantsLoading extends RestaurantsState {}
class RestaurantsLoaded extends RestaurantsState {
  final List<Restaurant> restaurants;
  const RestaurantsLoaded(this.restaurants);
  @override
  List<Object?> get props => [restaurants];
}
class RestaurantsError extends RestaurantsState {
  final String message;
  const RestaurantsError(this.message);
  @override
  List<Object?> get props => [message];
}
