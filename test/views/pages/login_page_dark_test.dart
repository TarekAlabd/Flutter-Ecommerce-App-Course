import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_cubits.dart';

void main() {
  testWidgets('LoginPage renders inside the dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: BlocProvider<AuthCubit>.value(
          value: FakeAuthCubit(),
          child: const LoginPage(),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(LoginPage)));
    expect(theme.brightness, Brightness.dark);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  test('login page has no literal white background', () {
    final source = File('lib/views/pages/login_page.dart').readAsStringSync();

    expect(source, isNot(contains('Colors.white')));
    expect(source, isNot(contains('AppColors.white')));
  });
}
