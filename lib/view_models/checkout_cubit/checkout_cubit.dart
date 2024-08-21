import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/checkout_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getCartItems() async {
    emit(CheckoutLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = dummyCart;
      final subtotal = cartItems.fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.product.price * element.quantity));
      final numOfProducts = cartItems.fold(
          0, (previousValue, element) => previousValue + element.quantity);

      final chosenPaymentCard =
          (await checkoutServices.fetchPaymentMethods(currentUser!.uid, true))
              .first;
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
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
