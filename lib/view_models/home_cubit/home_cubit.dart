import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      final currentUser = authServices.currentUser();
      final products = await homeServices.fetchProducts();
      final carouselItems = await homeServices.fetchCarouselItems();
      final favoriteProducts = await homeServices.fetchFavoriteProducts(
        currentUser!.uid,
      );

      final List<ProductItemModel> finalProducts = products.map((product) {
        final isFavorite = favoriteProducts.any(
          (item) => item.id == product.id,
        );
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      emit(HomeLoaded(
        carouselItems: carouselItems,
        products: finalProducts,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel product) async {
    emit(SetFavoriteLoading(product.id));
    try {
      final currentUser = authServices.currentUser();
      final favoriteProducts = await homeServices.fetchFavoriteProducts(
        currentUser!.uid,
      );
      final isFavorite = favoriteProducts.any(
        (item) => item.id == product.id,
      );
      if (isFavorite) {
        await homeServices.removeFavoriteProduct(
          userId: currentUser.uid,
          productId: product.id,
        );
      } else {
        await homeServices.addFavoriteProduct(
          userId: currentUser.uid,
          product: product,
        );
      }
      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
    } catch (e) {
      emit(SetFavoriteError(e.toString(), product.id));
    }
  }
}
