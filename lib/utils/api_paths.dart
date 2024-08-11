class ApiPaths {
  static String users(String userId) => 'users/$userId'; // users/$userId
  static String cartItem(String userId, String cartItemId) => 'users/$userId/cart/$cartItemId';
  static String products() => 'products/';
  static String product(String productId) => 'products/$productId';
}