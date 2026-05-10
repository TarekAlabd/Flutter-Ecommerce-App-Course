import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/views/pages/cart_page.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_cubits.dart';

void main() {
  testWidgets('CartPage renders inside the dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: CartPage(cartCubit: FakeCartCubit()),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(CartPage)));
    expect(theme.brightness, Brightness.dark);
    expect(find.byType(CartPage), findsOneWidget);
  });

  test('cart page has no literal white background', () {
    final source = File('lib/views/pages/cart_page.dart').readAsStringSync();

    expect(source, isNot(contains('Colors.white')));
    expect(source, isNot(contains('AppColors.white')));
  });
}
