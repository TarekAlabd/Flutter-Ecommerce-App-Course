import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/view_models/theme_cubit/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_theme_services.dart';

void main() {
  group('ThemeCubit', () {
    late FakeThemeServices service;

    test('initial state is light when initialIsDark is false', () {
      final cubit = ThemeCubit(
        themeServices: FakeThemeServices(),
        initialIsDark: false,
      );

      expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
    });

    test('initial state is dark when initialIsDark is true', () {
      final cubit = ThemeCubit(
        themeServices: FakeThemeServices(),
        initialIsDark: true,
      );

      expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
    });

    blocTest<ThemeCubit, ThemeState>(
      'toggleTheme from light emits dark and saves true',
      setUp: () {
        service = FakeThemeServices();
      },
      build: () {
        return ThemeCubit(themeServices: service, initialIsDark: false);
      },
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [
        isA<ThemeLoaded>().having(
          (state) => state.themeMode,
          'themeMode',
          ThemeMode.dark,
        ),
      ],
      verify: (_) => expect(service.savedValue, isTrue),
    );

    blocTest<ThemeCubit, ThemeState>(
      'toggleTheme from dark emits light and saves false',
      setUp: () {
        service = FakeThemeServices();
      },
      build: () {
        return ThemeCubit(themeServices: service, initialIsDark: true);
      },
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [
        isA<ThemeLoaded>().having(
          (state) => state.themeMode,
          'themeMode',
          ThemeMode.light,
        ),
      ],
      verify: (_) => expect(service.savedValue, isFalse),
    );

    blocTest<ThemeCubit, ThemeState>(
      'rapid successive toggles leave final state at last toggle',
      setUp: () {
        service = FakeThemeServices();
      },
      build: () {
        return ThemeCubit(themeServices: service, initialIsDark: false);
      },
      act: (cubit) async {
        await cubit.toggleTheme();
        await cubit.toggleTheme();
        await cubit.toggleTheme();
      },
      expect: () => [
        isA<ThemeLoaded>().having(
          (state) => state.themeMode,
          'themeMode',
          ThemeMode.dark,
        ),
        isA<ThemeLoaded>().having(
          (state) => state.themeMode,
          'themeMode',
          ThemeMode.light,
        ),
        isA<ThemeLoaded>().having(
          (state) => state.themeMode,
          'themeMode',
          ThemeMode.dark,
        ),
      ],
      verify: (_) => expect(service.savedValues, [true, false, true]),
    );
  });
}
