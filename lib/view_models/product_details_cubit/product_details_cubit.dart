import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/product_details_services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;

  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final selectedProduct =
          await productDetailsServices.fetchProductDetails(id);
      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     final selectedProduct =
    //         dummyProducts.firstWhere((item) => item.id == id);
    //     emit(ProductDetailsLoaded(product: selectedProduct));
    //   },
    // );
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  Future<void> addToCart(String productId) async {
    emit(ProductAddingToCart());
    try {
      final selectedProduct =
          await productDetailsServices.fetchProductDetails(productId);
      final currentUser = authServices.currentUser();
      
      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: selectedSize!,
        quantity: quantity,
      );
      await productDetailsServices.addToCart(cartItem, currentUser!.uid);
      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      emit(ProductAddToCartError(e.toString()));
    }
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
