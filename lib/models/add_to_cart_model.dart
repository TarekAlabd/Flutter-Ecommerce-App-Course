import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String productId;
  final ProductSize size;
  final int quantity;

  AddToCartModel({
    required this.productId,
    required this.size,
    required this.quantity,
  });

  AddToCartModel copyWith({
    String? productId,
    ProductSize? size,
    int? quantity,
  }) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}

List<AddToCartModel> dummyCart = [];