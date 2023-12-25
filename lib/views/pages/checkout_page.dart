import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/checkout_headlines_item.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Builder(builder: (context) {
          final cubit = BlocProvider.of<CheckoutCubit>(context);

          return BlocBuilder<CheckoutCubit, CheckoutState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is CheckoutLoaded ||
                current is CheckoutLoading ||
                current is CheckoutError,
            builder: (context, state) {
              if (state is CheckoutLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is CheckoutError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is CheckoutLoaded) {
                final cartItems = state.cartItems;
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      CheckoutHeadlinesItem(
                        title: 'Address',
                        onTap: () {},
                      ),
                      CheckoutHeadlinesItem(
                        title: 'Products',
                        numOfProducts: state.numOfProducts,
                      ),
                      const SizedBox(height: 16.0),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.grey2,
                          );
                        },
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Row(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.grey2,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: cartItem.product.imgUrl,
                                  height: 125,
                                  width: 125,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Size: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: AppColors.grey,
                                                ),
                                            children: [
                                              TextSpan(
                                                text: cartItem.size.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '\$${cartItem.totalPrice.toStringAsFixed(1)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      CheckoutHeadlinesItem(title: 'Payment'),
                      Divider(
                        color: AppColors.grey2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: AppColors.grey,
                                ),
                          ),
                          Text(
                            '\$${state.totalAmount.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Proceed to Buy'),
                        ),
                      ),
                    ],
                  ),
                ));
              } else {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
