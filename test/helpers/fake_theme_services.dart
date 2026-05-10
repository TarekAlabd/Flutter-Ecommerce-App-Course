import 'package:flutter_ecommerce_app/services/theme_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeThemeServices implements ThemeServices {
  FakeThemeServices({this.prefs});

  final SharedPreferences? prefs;
  final List<bool> savedValues = [];

  bool? get savedValue => savedValues.isEmpty ? null : savedValues.last;

  int get saveCallCount => savedValues.length;

  @override
  Future<void> saveIsDarkMode(bool isDark) async {
    savedValues.add(isDark);
    await prefs?.setBool('dark_mode_enabled', isDark);
  }
}
