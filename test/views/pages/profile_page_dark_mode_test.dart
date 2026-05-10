import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/theme_cubit/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/fake_theme_services.dart';

void main() {
  group('dark mode startup pattern', () {
    test('stored true creates dark initial state without intermediate light',
        () {
      final cubit = ThemeCubit(
        themeServices: FakeThemeServices(),
        initialIsDark: true,
      );

      expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
    });

    test('stored false or missing key creates light initial state', () {
      final cubit = ThemeCubit(
        themeServices: FakeThemeServices(),
        initialIsDark: false,
      );

      expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
    });

    test('toggleTheme updates SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(
        themeServices: FakeThemeServices(prefs: prefs),
        initialIsDark: false,
      );

      await cubit.toggleTheme();

      expect(prefs.getBool('dark_mode_enabled'), isTrue);
    });

    testWidgets('system dark brightness does not force app dark mode',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: BlocProvider(
            create: (_) => ThemeCubit(
              themeServices: FakeThemeServices(),
              initialIsDark: false,
            ),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final themeMode =
                    state is ThemeLoaded ? state.themeMode : ThemeMode.light;
                return MaterialApp(
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      brightness: Brightness.dark,
                    ),
                    useMaterial3: true,
                  ),
                  themeMode: themeMode,
                  home: const SizedBox(),
                );
              },
            ),
          ),
        ),
      );

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
    });
  });
}
