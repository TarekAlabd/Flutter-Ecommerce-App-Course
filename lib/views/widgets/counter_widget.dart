import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String productId;
  final dynamic cubit;

  const CounterWidget({
    super.key,
    required this.value, required this.productId, required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => cubit.decrementCounter(productId),
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: () => cubit.incrementCounter(productId),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
