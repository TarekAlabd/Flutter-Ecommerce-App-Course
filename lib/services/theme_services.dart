import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeServices {
  Future<void> saveIsDarkMode(bool isDark);
}

class ThemeServicesImpl implements ThemeServices {
  ThemeServicesImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'dark_mode_enabled';

  @override
  Future<void> saveIsDarkMode(bool isDark) => _prefs.setBool(_key, isDark);
}
