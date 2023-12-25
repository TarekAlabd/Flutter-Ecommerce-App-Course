part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<AddToCartModel> cartItems;
  final double totalAmount;
  final int numOfProducts;

  CheckoutLoaded({
    required this.cartItems,
    required this.totalAmount,
    required this.numOfProducts,
  });
}

final class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({
    required this.message,
  });
}
