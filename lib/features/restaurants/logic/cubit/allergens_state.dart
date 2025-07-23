import 'package:equatable/equatable.dart';
import 'package:gearpizza/features/restaurants/models/allergen.dart';

abstract class AllergensState extends Equatable {
  const AllergensState();
  @override
  List<Object?> get props => [];
}

class AllergensInitial extends AllergensState {}

class AllergensLoading extends AllergensState {}

class AllergensLoaded extends AllergensState {
  final List<Allergen> allergens;
  const AllergensLoaded(this.allergens);
  @override
  List<Object?> get props => [allergens];
}

class AllergensError extends AllergensState {
  final String message;
  const AllergensError(this.message);
  @override
  List<Object?> get props => [message];
}
