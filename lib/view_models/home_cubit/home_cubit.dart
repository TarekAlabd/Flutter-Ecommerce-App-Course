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
      final products = await homeServices.fetchProducts();
      final carouselItems = await homeServices.fetchCarouselItems();

      emit(HomeLoaded(
        carouselItems: carouselItems,
        products: products,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel product) async {
    emit(SetFavoriteLoading());
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
      emit(SetFavoriteSuccess(isFavorite: !isFavorite));
    } catch (e) {
      emit(SetFavoriteError(e.toString()));
    }
  }
}
