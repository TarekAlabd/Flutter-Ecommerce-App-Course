import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/cart_services.dart';
import 'package:flutter_ecommerce_app/services/favorite_services.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/services/home_services.dart';
import 'package:flutter_ecommerce_app/services/product_details_services.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';

class FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  FakeAuthCubit() : super(AuthInitial());

  @override
  AuthServicesImpl get authServices => throw UnimplementedError();

  @override
  FirestoreServices get firestoreServices => throw UnimplementedError();

  @override
  Future<void> authenticateWithFacebook() async {}

  @override
  Future<void> authenticateWithGoogle() async {}

  @override
  void checkAuth() {}

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {}

  @override
  Future<void> logout() async {
    emit(const AuthLoggedOut());
  }

  @override
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {}
}

class FakeHomeCubit extends Cubit<HomeState> implements HomeCubit {
  FakeHomeCubit() : super(HomeLoading());

  @override
  AuthServicesImpl get authServices => throw UnimplementedError();

  @override
  FavoriteServicesImpl get favoriteServices => throw UnimplementedError();

  @override
  HomeServicesImpl get homeServices => throw UnimplementedError();

  @override
  Future<void> getHomeData() async {}

  @override
  Future<void> setFavorite(ProductItemModel product) async {}
}

class FakeCartCubit extends Cubit<CartState> implements CartCubit {
  FakeCartCubit() : super(CartLoading());

  @override
  AuthServicesImpl get authServices => throw UnimplementedError();

  @override
  CartServicesImpl get cartServices => throw UnimplementedError();

  @override
  int quantity = 1;

  @override
  Future<void> decrementCounter(AddToCartModel cartItem,
      [int? initialValue]) async {}

  @override
  Future<void> getCartItems() async {}

  @override
  Future<void> incrementCounter(AddToCartModel cartItem,
      [int? initialValue]) async {}
}

class FakeProductDetailsCubit extends Cubit<ProductDetailsState>
    implements ProductDetailsCubit {
  FakeProductDetailsCubit() : super(ProductDetailsInitial());

  @override
  AuthServicesImpl get authServices => throw UnimplementedError();

  @override
  ProductDetailsServicesImpl get productDetailsServices =>
      throw UnimplementedError();

  @override
  int quantity = 1;

  @override
  ProductSize? selectedSize;

  @override
  Future<void> addToCart(String productId) async {}

  @override
  void decrementCounter(String productId) {}

  @override
  void getProductDetails(String id) {}

  @override
  void incrementCounter(String productId) {}

  @override
  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }
}
