import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/cart_services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  int quantity = 1;

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
      final subtotal = cartItems.fold<double>(
          0,
          (previousValue, item) =>
              previousValue + (item.product.price * item.quantity));
      emit(CartLoaded(cartItems, subtotal));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void incrementCounter(String productId, [int? initialValue]) {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity++;
    final index = dummyCart.indexWhere((item) => item.product.id == productId);
    dummyCart[index] = dummyCart[index].copyWith(quantity: quantity);
    emit(QuantityCounterLoaded(
      value: quantity,
      productId: productId,
    ));
    emit(SubtotalUpdated(_subtotal));
  }

  void decrementCounter(String productId, [int? initialValue]) {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity--;
    final index = dummyCart.indexWhere((item) => item.product.id == productId);
    dummyCart[index] = dummyCart[index].copyWith(quantity: quantity);
    emit(QuantityCounterLoaded(
      value: quantity,
      productId: productId,
    ));
    emit(SubtotalUpdated(_subtotal));
  }

  double get _subtotal => dummyCart.fold<double>(
      0,
      (previousValue, item) =>
          previousValue + (item.product.price * item.quantity));
}
