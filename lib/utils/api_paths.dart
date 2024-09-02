class ApiPaths {
  static String users(String userId) => 'users/$userId'; // users/$userId
  static String cartItem(String userId, String cartItemId) => 'users/$userId/cart/$cartItemId';
  static String location(String userId, String locationId) => 'users/$userId/locations/$locationId';
  static String locations(String userId) => 'users/$userId/locations/';
  static String paymentCard(String userId, String paymentId) => 'users/$userId/paymentCards/$paymentId';
  static String paymentCards(String userId) => 'users/$userId/paymentCards/';
  static String cartItems(String userId) => 'users/$userId/cart/';
  static String favoriteProduct(String userId, String productId) => 'users/$userId/favorites/$productId';
  static String favoriteProducts(String userId) => 'users/$userId/favorites/';
  static String products() => 'products/';
  static String announcements() => 'announcements/';
  static String categories() => 'categories/';
  static String product(String productId) => 'products/$productId';
}