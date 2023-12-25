import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(dummyCart.toString());
    return BlocProvider(
      create: (context) {
        final cubit = CartCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Builder(builder: (context) {
        final cubit = BlocProvider.of<CartCubit>(context);
        return BlocBuilder<CartCubit, CartState>(
          bloc: cubit,
          buildWhen: (previous, current) =>
              current is CartLoaded ||
              current is CartLoading ||
              current is CartError ||
              current is CartError,
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
                    const SizedBox(height: 16.0),
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
                    ),
                    BlocBuilder<CartCubit, CartState>(
                      bloc: cubit,
                      buildWhen: (previous, current) =>
                          current is SubtotalUpdated,
                      builder: (context, subtotalState) {
                        if (subtotalState is SubtotalUpdated) {
                          return Column(
                            children: [
                              totalAndSubtotalWidget(context,
                                  title: 'Subtotal',
                                  amount: subtotalState.subtotal),
                              totalAndSubtotalWidget(context,
                                  title: 'Shipping', amount: 10),
                              const SizedBox(height: 4.0),
                              Dash(
                                dashColor: AppColors.grey3,
                                length: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 4.0),
                              totalAndSubtotalWidget(
                                context,
                                title: 'Total Amount',
                                amount: subtotalState.subtotal + 10,
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            totalAndSubtotalWidget(context,
                                title: 'Subtotal', amount: state.subtotal),
                            totalAndSubtotalWidget(context,
                                title: 'Shipping', amount: 10),
                            const SizedBox(height: 4.0),
                            Dash(
                              dashColor: AppColors.grey3,
                              length: MediaQuery.of(context).size.width - 32,
                            ),
                            const SizedBox(height: 4.0),
                            totalAndSubtotalWidget(
                              context,
                              title: 'Total Amount',
                              amount: state.subtotal + 10,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(AppRoutes.checkoutRoute);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Checkout'),
                        ),
                      ),
                    ),
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
        );
      }),
    );
  }

  Widget totalAndSubtotalWidget(context,
      {required String title, required double amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.grey),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
