import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;

  void getProductDetails(String id) {
    emit(ProductDetailsLoading());
    Future.delayed(
      const Duration(seconds: 1),
      () {
        final selectedProduct =
            dummyProducts.firstWhere((item) => item.id == id);
        emit(ProductDetailsLoaded(product: selectedProduct));
      },
    );
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  void addToCart(String productId) {
    emit(ProductAddingToCart());
    final cartItem = AddToCartModel(
      id: DateTime.now().toIso8601String(),
      product: dummyProducts.firstWhere((item) => item.id == productId),
      size: selectedSize!,
      quantity: quantity,
    );
    dummyCart.add(cartItem);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        emit(
          ProductAddedToCart(productId: productId),
        );
      },
    );
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity));
  }

  void decrementCounter(String productId) {
    quantity--;
    emit(QuantityCounterLoaded(value: quantity));
  }
}
