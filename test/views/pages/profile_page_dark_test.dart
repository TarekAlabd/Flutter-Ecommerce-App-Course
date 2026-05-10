import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/theme_cubit/theme_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/profile_page.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_cubits.dart';
import '../../helpers/fake_theme_services.dart';

void main() {
  testWidgets('ProfilePage renders inside the dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>.value(value: FakeAuthCubit()),
              BlocProvider(
                create: (_) => ThemeCubit(
                  themeServices: FakeThemeServices(),
                  initialIsDark: true,
                ),
              ),
            ],
            child: const ProfilePage(),
          ),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(ProfilePage)));
    expect(theme.brightness, Brightness.dark);
    expect(find.byType(ProfilePage), findsOneWidget);
  });

  test('profile page has no literal white background', () {
    final source = File('lib/views/pages/profile_page.dart').readAsStringSync();

    expect(source, isNot(contains('Colors.white')));
    expect(source, isNot(contains('AppColors.white')));
  });
}
