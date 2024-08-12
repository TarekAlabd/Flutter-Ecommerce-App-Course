import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
  Future<List<HomeCarouselItemModel>> fetchCarouselItems();
  Future<List<CategoryModel>> fetchCategories();
  Future<List<ProductItemModel>> fetchFavoriteProducts(String userId);
  Future<void> addFavoriteProduct({
    required String userId,
    required ProductItemModel product,
  });
  Future<void> removeFavoriteProduct({
    required String userId,
    required String productId,
  });
}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final result = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(
        data,
      ),
    );
    return result;
  }

  @override
  Future<List<HomeCarouselItemModel>> fetchCarouselItems() async {
    final result = await firestoreServices.getCollection<HomeCarouselItemModel>(
      path: ApiPaths.announcements(),
      builder: (data, documentId) => HomeCarouselItemModel.fromMap(
        data,
      ),
    );
    return result;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final result = await firestoreServices.getCollection<CategoryModel>(
      path: ApiPaths.categories(),
      builder: (data, documentId) => CategoryModel.fromMap(
        data,
      ),
    );
    return result;
  }

  @override
  Future<void> addFavoriteProduct(
          {required String userId, required ProductItemModel product}) async =>
      await firestoreServices.setData(
        path: ApiPaths.favoriteProduct(userId, product.id),
        data: product.toMap(),
      );

  @override
  Future<void> removeFavoriteProduct(
          {required String userId, required String productId}) async =>
      await firestoreServices.deleteData(
        path: ApiPaths.favoriteProduct(userId, productId),
      );

  @override
  Future<List<ProductItemModel>> fetchFavoriteProducts(String userId) async {
    final result = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.favoriteProducts(userId),
      builder: (data, documentId) => ProductItemModel.fromMap(
        data,
      ),
    );
    return result;
  }
}
