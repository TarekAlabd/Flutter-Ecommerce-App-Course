import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/product_details_page.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_cubits.dart';

void main() {
  testWidgets('ProductDetailsPage renders inside the dark theme',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: BlocProvider<ProductDetailsCubit>.value(
          value: FakeProductDetailsCubit(),
          child: const ProductDetailsPage(productId: 'product-1'),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(ProductDetailsPage)));
    expect(theme.brightness, Brightness.dark);
    expect(find.byType(ProductDetailsPage), findsOneWidget);
  });

  test('product details page has no literal white background', () {
    final source =
        File('lib/views/pages/product_details_page.dart').readAsStringSync();

    expect(source, isNot(contains('Colors.white')));
    expect(source, isNot(contains('AppColors.white')));
  });
}
