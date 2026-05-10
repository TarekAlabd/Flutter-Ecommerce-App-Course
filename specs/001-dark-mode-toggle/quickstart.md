# Developer Quickstart: Dark Mode Toggle

**Branch**: `001-dark-mode-toggle`

## Prerequisites

Add `shared_preferences` to `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.5.5
```

Then run:

```bash
flutter pub get
```

## New Files to Create (TDD order)

Write tests first, then implementation:

| # | Test File | Implementation File |
|---|-----------|---------------------|
| 1 | `test/models/theme_preference_test.dart` | `lib/models/theme_preference.dart` |
| 2 | `test/services/theme_services_test.dart` | `lib/services/theme_services.dart` |
| 3 | `test/view_models/theme_cubit/theme_cubit_test.dart` | `lib/view_models/theme_cubit/theme_cubit.dart` + `theme_state.dart` |
| 4 | `test/views/widgets/dark_mode_toggle_row_test.dart` | `lib/views/widgets/dark_mode_toggle_row.dart` |

## Modified Files

| File | Change |
|------|--------|
| `pubspec.yaml` | Add `shared_preferences ^2.5.5` |
| `lib/main.dart` | Read prefs before runApp; pass `prefs` + `initialIsDark` to `MyApp`; add `ThemeCubit` to `MultiBlocProvider`; wrap `MaterialApp` in `BlocBuilder<ThemeCubit, ThemeState>` |
| `lib/views/pages/profile_page.dart` | Add `DarkModeToggleRow` above logout button |
| `lib/utils/app_colors.dart` | Document which constants are theme-independent |
| ~20 view/widget files | Replace `Colors.*` hardcoded references with `Theme.of(context).colorScheme.*` |

## main.dart Integration Pattern

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotification();

  final prefs = await SharedPreferences.getInstance();
  final initialIsDark = prefs.getBool('dark_mode_enabled') ?? false;

  runApp(MyApp(prefs: prefs, initialIsDark: initialIsDark));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs, required this.initialIsDark});
  final SharedPreferences prefs;
  final bool initialIsDark;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(
            themeServices: ThemeServicesImpl(prefs),
            initialIsDark: initialIsDark,
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit()..checkAuth(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (_) => FavoriteCubit()..getFavoriteProducts(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.light;
          return BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (_, current) =>
                current is AuthDone || current is AuthInitial,
            builder: (context, authState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'E-commerce App',
                navigatorKey: navigatorKey,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
                initialRoute: authState is AuthDone
                    ? AppRoutes.homeRoute
                    : AppRoutes.loginRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
```

## Running Tests

```bash
# Individual layer tests
flutter test test/models/theme_preference_test.dart
flutter test test/services/theme_services_test.dart
flutter test test/view_models/theme_cubit/theme_cubit_test.dart

# All tests + coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html  # optional HTML report

# Static analysis
flutter analyze
```

## Manual Verification Checklist

- [ ] Navigate to Profile tab — toggle row is visible above logout button
- [ ] Tap toggle — entire app switches to dark mode instantly (< 1 second)
- [ ] Tap toggle again — entire app returns to light mode
- [ ] Force-close and relaunch — active mode persists from first frame (no flash)
- [ ] Navigate to all screens — no white/light backgrounds in dark mode
- [ ] Verify status bar icons switch to light color in dark mode
- [ ] Enable accessibility (VoiceOver/TalkBack) — toggle announces "Dark mode, on/off"
- [ ] Rapidly toggle multiple times — final state persists correctly
- [ ] Check network traffic — zero new requests during theme switch

## Key Constraints

- `FR-011`: System theme setting must NOT influence the app. Never set `themeMode: ThemeMode.system`.
- `FR-012`: Zero network calls. `ThemeServices` touches only `SharedPreferences`.
- `SC-004`: WCAG AA contrast — Material 3 dark theme provides compliant defaults. Verify custom colors against 4.5:1 (normal text) and 3:1 (large text/icons).
