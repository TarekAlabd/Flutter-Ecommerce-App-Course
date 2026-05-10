import 'package:flutter/material.dart';

class AppColors {
  static const Color grey =
      Colors.grey; // deprecated: use ColorScheme surface variants instead
  static Color grey1 = Colors
      .grey.shade100; // deprecated: use ColorScheme surface variants instead
  static Color grey2 = Colors
      .grey.shade200; // deprecated: use ColorScheme surface variants instead
  static Color grey3 = Colors
      .grey.shade300; // deprecated: use ColorScheme surface variants instead
  static const Color white = Colors
      .white; // deprecated: use Theme.of(context).colorScheme.surface instead
  static const Color green = Colors.green; // theme-independent
  static const Color yellow = Colors.yellow; // theme-independent
  static const Color black = Colors
      .black; // deprecated: use Theme.of(context).colorScheme.onSurface instead
  static const Color black45 = Colors
      .black45; // deprecated: use Theme.of(context).colorScheme.onSurface.withOpacity(0.45) instead
  static const Color blue = Colors.blue; // theme-independent
  static const Color red = Colors.red; // theme-independent
  static const Color primary =
      Colors.deepPurple; // theme-independent brand primary
}
