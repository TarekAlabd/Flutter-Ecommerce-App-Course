import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final ProductSize size;
  final int quantity;

  AddToCartModel({
    required this.id,
    required this.product,
    required this.size,
    required this.quantity,
  });
}

List<AddToCartModel> dummyCart = [];
