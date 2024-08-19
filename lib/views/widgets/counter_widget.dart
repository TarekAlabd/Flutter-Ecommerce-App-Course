import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String? productId;
  final AddToCartModel? cartItem;
  final dynamic cubit;
  final int? initialValue;

  const CounterWidget({
    super.key,
    required this.value,
    this.productId,
    this.cartItem,
    required this.cubit,
    this.initialValue,
  }) : assert(productId != null || cartItem != null);

  // TODO: Implement the counter widget separately in the product details and the cart
  // This is just a workaround to make the code compile
  Future<void> decrementCounter(dynamic param) async {
    if (initialValue != null) {
      await cubit.decrementCounter(param, initialValue);
    } else {
      await cubit.decrementCounter(param);
    }
  }

  Future<void> incrementCounter(dynamic param) async {
    if (initialValue != null) {
      await cubit.incrementCounter(param, initialValue);
    } else {
      await cubit.incrementCounter(param);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => cartItem != null ? decrementCounter(cartItem) : decrementCounter(productId),
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: () => cartItem != null ? incrementCounter(cartItem) : incrementCounter(productId),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
