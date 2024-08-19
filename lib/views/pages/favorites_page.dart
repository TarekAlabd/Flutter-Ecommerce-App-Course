import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/favorite_cubit/favorite_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      bloc: favoriteCubit,
      buildWhen: (previous, current) =>
          current is FavoriteLoaded ||
          current is FavoriteLoading ||
          current is FavoriteError,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (state is FavoriteLoaded) {
          final favoriteProducts = state.favoriteProducts;
          if (favoriteProducts.isEmpty) {
            return const Center(
              child: Text('No favorite products'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await favoriteCubit.getFavoriteProducts();
            },
            child: ListView.separated(
              itemCount: favoriteProducts.length,
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 20,
                  endIndent: 20,
                  color: AppColors.grey2,
                );
              },
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.price.toString()),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.imgUrl),
                    radius: 25,
                  ),
                  trailing: BlocConsumer<FavoriteCubit, FavoriteState>(
                    bloc: favoriteCubit,
                    listenWhen: (previous, current) => current is FavoriteRemoveError,
                    listener: (context, state) {
                      if (state is FavoriteRemoveError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                          ),
                        );
                      } 
                    },
                    buildWhen: (previous, current) =>
                        (current is FavoriteRemoving &&
                            current.productId == product.id) ||
                        (current is FavoriteRemoved &&
                            current.productId == product.id) ||
                        current is FavoriteRemoveError,
                    builder: (context, state) {
                      if (state is FavoriteRemoving) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.red,
                        ),
                        onPressed: () async {
                          await favoriteCubit.removeFavorite(product.id);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else if (state is FavoriteError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
