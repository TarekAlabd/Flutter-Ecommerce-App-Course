import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  late ProductSize selectedSize;
  late int quantity;

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
      productId: productId,
      size: selectedSize,
      quantity: quantity,
    );
    dummyCart.add(cartItem);
    Future.delayed(
      const Duration(seconds: 1),
      () {
    emit(ProductAddedToCart(productId: productId),);
      },
    );
  }

  void incrementCounter(String productId) {
    final selectedIndex =
        dummyProducts.indexWhere((item) => item.id == productId);
    dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
      quantity: dummyProducts[selectedIndex].quantity + 1,
    );
    quantity = dummyProducts[selectedIndex].quantity;
    emit(QuantityCounterLoaded(value: dummyProducts[selectedIndex].quantity));
  }

  void decrementCounter(String productId) {
    final selectedIndex =
        dummyProducts.indexWhere((item) => item.id == productId);
    dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
      quantity: dummyProducts[selectedIndex].quantity - 1,
    );
    quantity = dummyProducts[selectedIndex].quantity;
    emit(QuantityCounterLoaded(value: dummyProducts[selectedIndex].quantity));
  }
}
