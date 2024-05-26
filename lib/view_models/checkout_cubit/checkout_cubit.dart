import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void getCartItems() {
    emit(CheckoutLoading());
    final cartItems = dummyCart;
    final subtotal = cartItems.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.product.price * element.quantity));
    final numOfProducts = cartItems.fold(
        0, (previousValue, element) => previousValue + element.quantity);
    final chosenPaymentCard = dummyPaymentCards.firstWhere(
      (element) => element.isChosen == true,
      orElse: () => dummyPaymentCards.first,
    );
    final chosenAddress = dummyLocations.firstWhere(
      (element) => element.isChosen == true,
      orElse: () => dummyLocations.first,
    );

    emit(
      CheckoutLoaded(
        cartItems: cartItems,
        totalAmount: subtotal + 10,
        numOfProducts: numOfProducts,
        chosenPaymentCard: chosenPaymentCard,
        chosenAddress: chosenAddress,
      ),
    );
  }
}
