part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.carouselItems,
    required this.products,
  });

  final List<HomeCarouselItemModel> carouselItems;
  final List<ProductItemModel> products;
}

final class HomeError extends HomeState {
  HomeError(this.message);

  final String message;
}

final class SetFavoriteLoading extends HomeState {}

final class SetFavoriteSuccess extends HomeState {
  final bool isFavorite;

  SetFavoriteSuccess({required this.isFavorite});
}

final class SetFavoriteError extends HomeState {
  SetFavoriteError(this.message);

  final String message;
}
