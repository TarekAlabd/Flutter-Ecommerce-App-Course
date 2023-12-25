import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(dummyCart.toString());
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CartCubit, CartState>(
        bloc: BlocProvider.of<CartCubit>(context),
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;
            if (cartItems.isEmpty) {
              return const Center(
                child: Text('No items in your cart!'),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return CartItemWidget(cartItem: cartItem);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: AppColors.grey2,
                      );
                    },
                  ),
                  Divider(
                    color: AppColors.grey2,
                  )
                ],
              ),
            );
          } else if (state is CartError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
    );
  }
}
