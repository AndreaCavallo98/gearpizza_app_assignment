class GearPizzaAppException implements Exception {
  final String message;

  GearPizzaAppException(this.message);

  @override
  String toString() => message;
}