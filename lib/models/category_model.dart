class CategoryModel {
  final String id;
  final String name;
  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'productsCount': productsCount});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      productsCount: map['productsCount']?.toInt() ?? 0,
    );
  }
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
  ),
];
