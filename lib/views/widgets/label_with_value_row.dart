import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class LabelWithValueRow extends StatelessWidget {
  final String label;
  final String value;
  const LabelWithValueRow({super.key, required this.label, required this.value,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.grey,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
