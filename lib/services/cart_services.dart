import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
}

class CartServicesImpl implements CartServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.cartItems(userId),
        builder: (data, documentId) => AddToCartModel.fromMap(data),
      );
}
