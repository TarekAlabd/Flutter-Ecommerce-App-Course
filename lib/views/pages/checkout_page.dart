import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                return SingleChildScrollView(
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
                    CheckoutHeadlinesItem(title: 'Payment'),
                  ],
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
