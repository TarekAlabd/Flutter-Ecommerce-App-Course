# Research: Dark Mode Toggle

**Phase 0 output** | Branch: `001-dark-mode-toggle` | Date: 2026-05-10

## 1. Persistence: shared_preferences

**Decision**: Use `shared_preferences ^2.5.5` with a single bool key `dark_mode_enabled`.

**Rationale**: Already implied in spec assumptions (FR-012 says "local device storage only"). `shared_preferences` is the de facto Flutter key-value store for lightweight preferences. It requires no schema migrations, no extra setup, and works offline. Latest stable version is 2.5.5 (pub score 140, last published within 6 months — meets constitution's pub score and recency requirements).

**API used**:
```dart
final prefs = await SharedPreferences.getInstance();
final isDark = prefs.getBool('dark_mode_enabled') ?? false;  // read
await prefs.setBool('dark_mode_enabled', isDark);             // write
```

**Alternatives considered**:
- `SharedPreferencesAsync` / `SharedPreferencesWithCache` — pub.dev marks the legacy API as being superseded, but both new APIs are still in preview. Legacy `getInstance()` is stable and correct for this use case.
- `flutter_secure_storage` — unnecessary; theme preference is not sensitive data.
- `hive` / `isar` — over-engineered for a single boolean preference.

---

## 2. No-Flash Theme Pattern

**Decision**: Read `SharedPreferences` in `main()` before `runApp()` and pass the value as the `ThemeCubit` initial state.

**Rationale**: If the preference is read asynchronously inside the cubit (e.g., via `init()` method after construction), the cubit emits a second state after the first frame, causing a visible flash. Reading synchronously in `main()` before `runApp()` means the cubit is constructed with the correct initial state — the first frame is already correct.

**Pattern**:
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotification();

  final prefs = await SharedPreferences.getInstance();
  final initialIsDark = prefs.getBool('dark_mode_enabled') ?? false;

  runApp(MyApp(prefs: prefs, initialIsDark: initialIsDark));
}
```

`ThemeCubit` constructor receives both `prefs` (for future saves) and `initialIsDark` (for initial state):
```dart
ThemeCubit({required SharedPreferences prefs, required bool initialIsDark})
    : _themeServices = ThemeServicesImpl(prefs),
      super(ThemeLoaded(initialIsDark ? ThemeMode.dark : ThemeMode.light));
```

`MyApp` wraps `MultiBlocProvider` and passes through `prefs` and `initialIsDark`.

**Alternatives considered**:
- Reading inside the cubit constructor: triggers a flash on first frame. Rejected.
- Using Flutter's system theme (`ThemeMode.system`): violates FR-011 (system theme must not influence app). Rejected.

---

## 3. ThemeCubit + MaterialApp Integration

**Decision**: Wrap `MaterialApp` in `BlocBuilder<ThemeCubit, ThemeState>` and drive `themeMode` from cubit state.

**Rationale**: `MaterialApp.themeMode` is the single Flutter control point for theme switching. Pairing it with a `BlocBuilder` is the cleanest and most idiomatic flutter_bloc approach. The entire widget tree rebuilds when `ThemeCubit` emits, which propagates the new theme to every screen.

**Pattern**:
```dart
BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    final themeMode = state is ThemeLoaded ? state.themeMode : ThemeMode.light;
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      ...
    );
  },
)
```

The existing `BlocBuilder<AuthCubit, AuthState>` (which controls `initialRoute`) is nested inside the `ThemeCubit` builder so both builders compose correctly.

**Alternatives considered**:
- `AnimatedTheme` with custom transitions: out of scope per spec (animated transitions not required).
- `provider` package: project uses `flutter_bloc` exclusively per constitution.
- `adaptive_theme` package: introduces an extra dependency; ThemeCubit approach is self-contained and testable.

---

## 4. Hardcoded Color Migration Strategy

**Decision**: Replace `Colors.*` / `AppColors.*` hardcoded references with `Theme.of(context).colorScheme.*` and `Theme.of(context).scaffoldBackgroundColor` in all view files.

**Scope**: ~20 files contain `Colors.*` references (identified via `grep -r "Colors\." lib --include="*.dart" -l`).

**Mapping**:
| Hardcoded | Theme-aware replacement |
|-----------|------------------------|
| `Colors.white` / `AppColors.white` | `Theme.of(context).colorScheme.surface` |
| `Colors.grey.shade100/200/300` | `Theme.of(context).colorScheme.surfaceContainerLow/High` |
| `Colors.black` / `AppColors.black` | `Theme.of(context).colorScheme.onSurface` |
| `Colors.black45` | `Theme.of(context).colorScheme.onSurface.withOpacity(0.45)` |
| `Colors.deepPurple` / `AppColors.primary` | `Theme.of(context).colorScheme.primary` — kept as brand color |
| Scaffold `backgroundColor: Colors.white` | Remove; `ThemeData` scaffold background is set by `ThemeData.dark/light` |

`AppColors` retains semantic constants for colors that are theme-independent (e.g., `green` for success, `red` for error, `blue` for links). Brand color `primary = Colors.deepPurple` stays.

**Rationale**: Using Material 3 `ColorScheme` is the Flutter-recommended approach and ensures WCAG AA contrast ratios are maintained by `ThemeData.dark(useMaterial3: true)`. Custom dark theme tweaks are applied via `.copyWith()` on the base `ThemeData.dark()`.

---

## 5. Accessibility (FR-013)

**Decision**: `DarkModeToggleRow` widget wraps the `Switch` in a `Semantics` widget with `label: 'Dark mode'` and `toggled: isDark`.

**Rationale**: Required by FR-013. VoiceOver (iOS) and TalkBack (Android) will announce "Dark mode, on/off" correctly.

**Pattern**:
```dart
Semantics(
  label: 'Dark mode',
  toggled: isDark,
  child: Switch(value: isDark, onChanged: onToggle),
)
```

---

## All NEEDS CLARIFICATION items resolved

All unknowns are resolved. No open questions remain before implementation.
