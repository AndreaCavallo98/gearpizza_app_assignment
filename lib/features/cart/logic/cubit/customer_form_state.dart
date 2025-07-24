import 'package:equatable/equatable.dart';

class CustomerFormState extends Equatable {
  final bool isSubmitting;
  final bool success;
  final Map<String, String> backendErrors;
  final String? genericError;
  final bool? customerAlreadyExists;

  const CustomerFormState({
    required this.isSubmitting,
    required this.success,
    required this.backendErrors,
    this.genericError,
    this.customerAlreadyExists = false,
  });

  factory CustomerFormState.initial() {
    return const CustomerFormState(
      isSubmitting: false,
      success: false,
      backendErrors: {},
      genericError: null,
    );
  }

  CustomerFormState copyWith({
    bool? isSubmitting,
    bool? success,
    Map<String, String>? backendErrors,
    String? genericError,
    final bool? customerAlreadyExists,
  }) {
    return CustomerFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      backendErrors: backendErrors ?? this.backendErrors,
      genericError: genericError,
      customerAlreadyExists: customerAlreadyExists,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    success,
    backendErrors,
    genericError,
  ];
}
