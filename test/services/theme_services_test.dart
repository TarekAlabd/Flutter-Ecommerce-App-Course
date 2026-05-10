import 'package:flutter_ecommerce_app/services/theme_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeServicesImpl', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveIsDarkMode writes true to SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      final service = ThemeServicesImpl(prefs);

      await service.saveIsDarkMode(true);

      expect(prefs.getBool('dark_mode_enabled'), isTrue);
    });

    test('saveIsDarkMode writes false to SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      final service = ThemeServicesImpl(prefs);

      await service.saveIsDarkMode(false);

      expect(prefs.getBool('dark_mode_enabled'), isFalse);
    });

    test('saved true value can be read directly from SharedPreferences',
        () async {
      final prefs = await SharedPreferences.getInstance();
      final service = ThemeServicesImpl(prefs);

      await service.saveIsDarkMode(true);

      expect(prefs.getBool('dark_mode_enabled'), true);
    });

    test('saved false value can be read directly from SharedPreferences',
        () async {
      final prefs = await SharedPreferences.getInstance();
      final service = ThemeServicesImpl(prefs);

      await service.saveIsDarkMode(false);

      expect(prefs.getBool('dark_mode_enabled'), false);
    });

    test('only writes the local theme preference key', () async {
      SharedPreferences.setMockInitialValues({'existing_key': 'kept'});
      final prefs = await SharedPreferences.getInstance();
      final service = ThemeServicesImpl(prefs);

      await service.saveIsDarkMode(true);

      expect(
          prefs.getKeys(), containsAll({'existing_key', 'dark_mode_enabled'}));
      expect(prefs.getString('existing_key'), 'kept');
    });
  });
}
