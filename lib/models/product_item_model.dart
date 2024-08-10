import 'dart:convert';

enum ProductSize {
  S,
  M,
  L,
  XL,
}

class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final double price;
  final bool isFavorite;
  final String category;
  final double averageRate;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.description =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    required this.price,
    this.isFavorite = false,
    required this.category,
    this.averageRate = 4.5,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? description,
    double? price,
    bool? isFavorite,
    String? category,
    double? averageRate,
    int? quantity,
    ProductSize? size,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      averageRate: averageRate ?? this.averageRate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'imgUrl': imgUrl});
    result.addAll({'description': description});
    result.addAll({'price': price});
    result.addAll({'isFavorite': isFavorite});
    result.addAll({'category': category});
    result.addAll({'averageRate': averageRate});
  
    return result;
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductItemModel(
      id: documentId,
      name: map['name'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isFavorite: map['isFavorite'] ?? false,
      category: map['category'] ?? '',
      averageRate: map['averageRate']?.toDouble() ?? 0.0,
    );
  }
}

List<ProductItemModel> dummyProducts = [
  ProductItemModel(
    id: '1',
    name: 'T-shirt',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/07/Tshirtpng.parspng.com_.png',
    price: 10,
    category: 'Clothes',
  ),
  ProductItemModel(
    id: '2',
    name: 'Black Shoes',
    imgUrl: 'https://pngimg.com/d/men_shoes_PNG7475.png',
    price: 20,
    category: 'Shoes',
  ),
  ProductItemModel(
    id: '3',
    name: 'Trousers',
    imgUrl:
        'https://www.pngall.com/wp-content/uploads/2016/09/Trouser-Free-Download-PNG.png',
    price: 30,
    category: 'Clothes',
  ),
  ProductItemModel(
    id: '4',
    name: 'Pack of Tomatoes',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/12/tomatopng.parspng.com-6.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: '5',
    name: 'Pack of Potatoes',
    imgUrl: 'https://pngimg.com/d/potato_png2398.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: '6',
    name: 'Pack of Onions',
    imgUrl: 'https://pngimg.com/d/onion_PNG99213.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: '7',
    name: 'Pack of Apples',
    imgUrl: 'https://pngfre.com/wp-content/uploads/apple-43-1024x1015.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: '8',
    name: 'Pack of Oranges',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/05/orangepng.parspng.com_-1.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: '9',
    name: 'Pack of Bananas',
    imgUrl:
        'https://static.vecteezy.com/system/resources/previews/015/100/096/original/bananas-transparent-background-free-png.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: '10',
    name: 'Pack of Mangoes',
    imgUrl: 'https://purepng.com/public/uploads/large/mango-tgy.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: '11',
    name: 'Sweet Shirt',
    imgUrl:
        'https://www.usherbrand.com/cdn/shop/products/5uYjJeWpde9urtZyWKwFK4GHS6S3thwKRuYaMRph7bBDyqSZwZ_87x1mq24b2e7_1800x1800.png',
    price: 15,
    category: 'Clothes',
  ),
];
