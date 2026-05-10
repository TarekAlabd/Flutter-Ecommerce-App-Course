import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/views/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_cubits.dart';

void main() {
  testWidgets('HomePage renders inside the dark theme and keeps brand primary',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: HomePage(homeCubit: FakeHomeCubit()),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.byType(HomePage)));
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, isNot(Colors.black));
    expect(theme.colorScheme.primary, isNot(Colors.white));
    expect(find.byType(HomePage), findsOneWidget);
  });

  test('home page has no literal white backgrounds or image tints', () {
    final source = File('lib/views/pages/home_page.dart').readAsStringSync();
    final homeTabSource =
        File('lib/views/widgets/home_tab_view.dart').readAsStringSync();

    expect(source, isNot(contains('Colors.white')));
    expect(source, isNot(contains('AppColors.white')));
    expect(homeTabSource, isNot(contains('colorBlendMode')));
    expect(homeTabSource, isNot(contains('Colors.white')));
    expect(homeTabSource, isNot(contains('AppColors.white')));
  });
}
