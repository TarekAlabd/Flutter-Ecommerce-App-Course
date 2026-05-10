import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/services/theme_services.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required ThemeServices themeServices,
    required bool initialIsDark,
  })  : _themeServices = themeServices,
        super(ThemeLoaded(initialIsDark ? ThemeMode.dark : ThemeMode.light));

  final ThemeServices _themeServices;

  Future<void> toggleTheme() async {
    final current = state as ThemeLoaded;
    final isDark = current.themeMode == ThemeMode.dark;
    await _themeServices.saveIsDarkMode(!isDark);
    emit(ThemeLoaded(!isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
