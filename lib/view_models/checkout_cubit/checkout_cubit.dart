import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/cart_services.dart';
import 'package:flutter_ecommerce_app/services/checkout_services.dart';
import 'package:flutter_ecommerce_app/services/location_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();
  final locationServices = LocationServicesImpl();
  final cartServices = CartServicesImpl();

  Future<void> getCheckoutContent() async {
    emit(CheckoutLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
      double shippingValue = 10;
      final subtotal = cartItems.fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.product.price * element.quantity));
      final numOfProducts = cartItems.fold(
          0, (previousValue, element) => previousValue + element.quantity);

      final chosenPaymentCard =
          (await checkoutServices.fetchPaymentMethods(currentUser.uid, true))
              .first;
      final chosenAddress = (await locationServices.fetchLocations(
        currentUser.uid,
        true,
      ))
          .first;

      emit(
        CheckoutLoaded(
          cartItems: cartItems,
          totalAmount: subtotal + shippingValue,
          subtotal: subtotal,
          shippingValue: shippingValue,
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
