import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/favorite_services.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final favoriteServices = FavoriteServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getFavoriteProducts() async {
    emit(FavoriteLoading());
    try {
      final currentUser = authServices.currentUser();
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser!.uid,
      );
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    emit(FavoriteRemoving(productId));
    try {
      final currentUser = authServices.currentUser();
      await favoriteServices.removeFavorite(
        currentUser!.uid,
        productId,
      );
      emit(FavoriteRemoved(productId));
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteRemoveError(e.toString()));
    }
  
  }
}
