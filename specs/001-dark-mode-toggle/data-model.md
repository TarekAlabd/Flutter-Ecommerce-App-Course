# Data Model: Dark Mode Toggle

**Phase 1 output** | Branch: `001-dark-mode-toggle` | Date: 2026-05-10

## Entities

### ThemePreference

**Purpose**: Persisted user preference for display mode. Stored in `SharedPreferences`.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `isDarkMode` | `bool` | `false` | `true` = dark mode active; `false` = light mode |

**File**: `lib/models/theme_preference.dart`

**Contract**:
- All fields `final` (immutable)
- `factory ThemePreference.fromMap(Map<String, dynamic> map)` — reads `isDarkMode` key with safe bool default `false`
- `Map<String, dynamic> toMap()` — returns `{'isDarkMode': isDarkMode}`
- `ThemePreference copyWith({bool? isDarkMode})` — returns new instance

**Storage key**: `dark_mode_enabled` (bool) in SharedPreferences

**State transitions**:
```
[Default / Fresh Install]
  isDarkMode = false  (light mode)

[User taps toggle: light → dark]
  isDarkMode = false  →  isDarkMode = true
  Persisted immediately via ThemeServices.saveIsDarkMode(true)

[User taps toggle: dark → light]
  isDarkMode = true   →  isDarkMode = false
  Persisted immediately via ThemeServices.saveIsDarkMode(false)
```

---

### ThemeState (In-Memory Cubit State)

**Purpose**: Runtime Cubit state representing the active theme. Derived from `ThemePreference` on startup; updated on each toggle.

**File**: `lib/view_models/theme_cubit/theme_state.dart`

**Sealed class hierarchy**:
```dart
sealed class ThemeState { const ThemeState(); }

final class ThemeLoaded extends ThemeState {
  const ThemeLoaded(this.themeMode);
  final ThemeMode themeMode;  // ThemeMode.light | ThemeMode.dark
}
```

**Transitions**:
- `ThemeCubit` is constructed with `ThemeLoaded(ThemeMode.light or ThemeMode.dark)` — initial state is correct from the first frame (no loading state ever emitted)
- `toggleTheme()` → emits `ThemeLoaded(ThemeMode.dark)` or `ThemeLoaded(ThemeMode.light)` based on current state

---

## Service Interface

**File**: `lib/services/theme_services.dart`

```dart
abstract class ThemeServices {
  Future<void> saveIsDarkMode(bool isDark);
}

class ThemeServicesImpl implements ThemeServices {
  ThemeServicesImpl(this._prefs);
  final SharedPreferences _prefs;
  static const _key = 'dark_mode_enabled';

  @override
  Future<void> saveIsDarkMode(bool isDark) =>
      _prefs.setBool(_key, isDark);
}
```

> Note: Reading the preference is done once in `main()` via `prefs.getBool('dark_mode_enabled') ?? false` before `runApp()`. The service only needs `save` — the single read at startup is handled outside the service to enable no-flash initialization.

---

## Cubit Interface

**File**: `lib/view_models/theme_cubit/theme_cubit.dart`

```dart
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemeServices themeServices, required bool initialIsDark})
      : _themeServices = themeServices,
        super(ThemeLoaded(initialIsDark ? ThemeMode.dark : ThemeMode.light));

  final ThemeServices _themeServices;

  Future<void> toggleTheme() async {
    final current = state as ThemeLoaded;
    final isDark = current.themeMode == ThemeMode.dark;
    await _themeServices.saveIsDarkMode(!isDark);
    emit(ThemeLoaded(!isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
```

---

## Widget Interface

**File**: `lib/views/widgets/dark_mode_toggle_row.dart`

```dart
// Row: [Icon(sun/moon)] [Text("Dark mode")] [Spacer] [Switch]
// Wraps Switch in Semantics(label: 'Dark mode', toggled: isDark)
// Calls context.read<ThemeCubit>().toggleTheme() on switch change
```

**Placement**: Profile page (`lib/views/pages/profile_page.dart`), above the logout button.

---

## Relationships

```
SharedPreferences (device storage)
    ↕  read: main()
    ↕  write: ThemeServicesImpl
ThemePreference (model, in-memory after read)
    → ThemeCubit (initial state)
ThemeCubit (global, MultiBlocProvider in main.dart)
    → MaterialApp.themeMode (via BlocBuilder)
    → DarkModeToggleRow (reads current state, emits toggle)
```
