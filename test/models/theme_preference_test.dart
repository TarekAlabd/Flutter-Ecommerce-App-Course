import 'package:flutter_ecommerce_app/models/theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemePreference', () {
    test('fromMap reads true value', () {
      final preference = ThemePreference.fromMap({'isDarkMode': true});

      expect(preference.isDarkMode, isTrue);
    });

    test('fromMap reads false value', () {
      final preference = ThemePreference.fromMap({'isDarkMode': false});

      expect(preference.isDarkMode, isFalse);
    });

    test('fromMap defaults missing value to false', () {
      final preference = ThemePreference.fromMap({});

      expect(preference.isDarkMode, isFalse);
    });

    test('toMap writes isDarkMode value', () {
      const preference = ThemePreference(isDarkMode: true);

      expect(preference.toMap(), {'isDarkMode': true});
    });

    test('copyWith returns updated value', () {
      const preference = ThemePreference(isDarkMode: false);

      expect(preference.copyWith(isDarkMode: true).isDarkMode, isTrue);
    });

    test('copyWith does not mutate the original instance', () {
      const preference = ThemePreference(isDarkMode: false);
      final updated = preference.copyWith(isDarkMode: true);

      expect(preference.isDarkMode, isFalse);
      expect(updated.isDarkMode, isTrue);
    });
  });
}
