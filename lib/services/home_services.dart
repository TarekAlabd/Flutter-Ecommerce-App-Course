import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
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
}
