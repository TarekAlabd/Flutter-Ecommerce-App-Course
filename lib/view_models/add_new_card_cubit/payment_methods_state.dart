part of 'payment_methods_cubit.dart';

sealed class PaymentMethodsState {}

final class PaymntMethodsInitial extends PaymentMethodsState {}

final class AddNewCardLoading extends PaymentMethodsState {}

final class AddNewCardSuccess extends PaymentMethodsState {}

final class AddNewCardFailure extends PaymentMethodsState {
  final String errorMessage;

  AddNewCardFailure(this.errorMessage);
}

final class FetchingPaymentMethods extends PaymentMethodsState {}

final class FetchedPaymentMethods extends PaymentMethodsState {
  final List<PaymentCardModel> paymentCards;

  FetchedPaymentMethods(this.paymentCards);
}

final class FetchPaymentMethodsError extends PaymentMethodsState {
  final String errorMessage;

  FetchPaymentMethodsError(this.errorMessage);
}
