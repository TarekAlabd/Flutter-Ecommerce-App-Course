import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final ProductSize size;
  final int quantity;

  const AddToCartModel({
    required this.id,
    required this.product,
    required this.size,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  AddToCartModel copyWith({
    String? id,
    ProductItemModel? product,
    ProductSize? size,
    int? quantity,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'product': product.toMap()});
    result.addAll({'size': size.name});
    result.addAll({'quantity': quantity});
  
    return result;
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'] ?? '',
      product: ProductItemModel.fromMap(map['product']),
      size: ProductSize.fromString(map['size']),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}

List<AddToCartModel> dummyCart = [];
