import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/favorite_services.dart';
import 'package:flutter_ecommerce_app/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServicesImpl();
  final authServices = AuthServicesImpl();
  final favoriteServices = FavoriteServicesImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      final currentUser = authServices.currentUser();
      final products = await homeServices.fetchProducts();
      final carouselItems = await homeServices.fetchCarouselItems();
      final favoriteProducts = await favoriteServices.getFavorites(
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
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser!.uid,
      );
      final isFavorite = favoriteProducts.any(
        (item) => item.id == product.id,
      );
      if (isFavorite) {
        await favoriteServices.removeFavorite(
          currentUser.uid,
          product.id,
        );
      } else {
        await favoriteServices.addFavorite(
          currentUser.uid,
          product,
        );
      }
      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
    } catch (e) {
      emit(SetFavoriteError(e.toString(), product.id));
    }
  }
}
