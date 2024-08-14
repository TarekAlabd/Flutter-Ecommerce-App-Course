import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class FavoriteServices {
  Future<void> addFavorite(String userId, ProductItemModel product);
  Future<void> removeFavorite(String userId, String productId);
  Future<List<ProductItemModel>> getFavorites(String userId);
}

class FavoriteServicesImpl implements FavoriteServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addFavorite(String userId, ProductItemModel product) async =>
      await firestoreServices.setData(
        path: ApiPaths.favoriteProduct(userId, product.id),
        data: product.toMap(),
      );

  @override
  Future<List<ProductItemModel>> getFavorites(String userId) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.favoriteProducts(userId),
        builder: (data, documentId) => ProductItemModel.fromMap(data),
      );

  @override
  Future<void> removeFavorite(String userId, String productId) async =>
      await firestoreServices.deleteData(
        path: ApiPaths.favoriteProduct(userId, productId),
      );
}
