import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServicesImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      final products = await homeServices.fetchProducts();
      final carouselItems = dummyHomeCarouselItems;
      
      emit(HomeLoaded(
        carouselItems: carouselItems,
        products: products,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
    // Future.delayed(const Duration(seconds: 1), () {
    //   emit(HomeLoaded(
    //     carouselItems: dummyHomeCarouselItems,
    //     products: dummyProducts,
    //   ));
    // });
  }
}
