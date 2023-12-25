import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  int quantity = 1;

  void getCartItems() async {
    emit(CartLoading());
    final subtotal = dummyCart.fold<double>(
        0, (previousValue, item) => previousValue + item.product.price);
    emit(CartLoaded(dummyCart, subtotal));
  }

  void incrementCounter(String productId, [int? initialValue]) {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity++;
    emit(QuantityCounterLoaded(value: quantity, productId: productId,));
  }

  void decrementCounter(String productId, [int? initialValue]) {
    if (initialValue != null) {
      quantity = initialValue;
    }
    quantity--;
    emit(QuantityCounterLoaded(value: quantity, productId: productId,));
  }
}
