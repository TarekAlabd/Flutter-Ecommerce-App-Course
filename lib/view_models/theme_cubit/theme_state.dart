part of 'theme_cubit.dart';

sealed class ThemeState {
  const ThemeState();
}

final class ThemeLoaded extends ThemeState {
  const ThemeLoaded(this.themeMode);

  final ThemeMode themeMode;
}
