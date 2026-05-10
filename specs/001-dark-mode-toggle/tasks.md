# Tasks: Dark Mode Toggle

**Input**: Design documents from `specs/001-dark-mode-toggle/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, quickstart.md ✅
**Branch**: `001-dark-mode-toggle`

## Context for Implementer (Read Before Starting)

This is a Flutter e-commerce app using **MVVM + BLoC/Cubit**. Read the following before implementing:
- `specs/001-dark-mode-toggle/plan.md` — architecture decisions and file structure
- `specs/001-dark-mode-toggle/data-model.md` — exact class signatures and code snippets
- `specs/001-dark-mode-toggle/research.md` — rationale for every technical decision
- `specs/001-dark-mode-toggle/quickstart.md` — the exact `main.dart` pattern to follow

Key constraints that must NEVER be violated:
- **FR-011**: Never use `ThemeMode.system` — only the in-app toggle controls theme.
- **FR-012**: Zero network calls for theme — `ThemeServices` touches only `SharedPreferences`.
- **Constitution I**: No business logic in widgets. All state in `ThemeCubit`.
- **Constitution II**: Abstract `ThemeServices` interface; `ThemeServicesImpl` is the concrete class.
- **Constitution III**: All model fields `final`. Use `copyWith` for updates.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no unmet dependencies)
- **[Story]**: User story label — [US1], [US2], [US3]
- All file paths are relative to the repository root

## Color Migration Reference (for US3 tasks)

| Hardcoded | Theme-aware replacement |
|-----------|------------------------|
| `Colors.white` / `AppColors.white` | `Theme.of(context).colorScheme.surface` |
| `Colors.grey.shade100` | `Theme.of(context).colorScheme.surfaceContainerLow` |
| `Colors.grey.shade200` | `Theme.of(context).colorScheme.surfaceContainerHighest` |
| `Colors.grey.shade300` / `Colors.grey` | `Theme.of(context).colorScheme.surfaceContainerHigh` |
| `Colors.black` / `AppColors.black` | `Theme.of(context).colorScheme.onSurface` |
| `Colors.black45` | `Theme.of(context).colorScheme.onSurface.withOpacity(0.45)` |
| `Colors.deepPurple` / `AppColors.primary` | `Theme.of(context).colorScheme.primary` |
| Scaffold `backgroundColor: Colors.white` | Remove the `backgroundColor` param; ThemeData handles it |
| `Colors.green` / `Colors.red` / `Colors.blue` | KEEP — theme-independent semantic colors |

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add the new dependency before any code is written.

- [ ] T001 Add `shared_preferences: ^2.5.5` under `dependencies` in `pubspec.yaml`
  - Open `pubspec.yaml` and add `shared_preferences: ^2.5.5` in the `dependencies` block, below the existing `flutter_bloc` entry.
  - Do NOT change any other dependency versions.

- [ ] T002 Run `flutter pub get` from the project root to install `shared_preferences`
  - Execute: `flutter pub get`
  - Verify the command succeeds with no errors before continuing.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create the theme layer — model, service, state, and cubit — that all user stories depend on.

**⚠️ CRITICAL**: No user story work can begin until all Phase 2 tasks are complete.

> All four tasks below are creating NEW files in different directories and can be done in parallel.

- [ ] T003 [P] Create `lib/models/theme_preference.dart` — immutable `ThemePreference` model
  - Exact implementation required:
    ```dart
    class ThemePreference {
      const ThemePreference({required this.isDarkMode});
      final bool isDarkMode;

      factory ThemePreference.fromMap(Map<String, dynamic> map) =>
          ThemePreference(isDarkMode: (map['isDarkMode'] as bool?) ?? false);

      Map<String, dynamic> toMap() => {'isDarkMode': isDarkMode};

      ThemePreference copyWith({bool? isDarkMode}) =>
          ThemePreference(isDarkMode: isDarkMode ?? this.isDarkMode);
    }
    ```
  - All fields must be `final`. No mutations allowed.

- [ ] T004 [P] Create `lib/services/theme_services.dart` — abstract `ThemeServices` + `ThemeServicesImpl`
  - Exact implementation required:
    ```dart
    import 'package:shared_preferences/shared_preferences.dart';

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
  - Reading from SharedPreferences is intentionally NOT in the service (done once in `main()` before `runApp()` to avoid flash of wrong theme).

- [ ] T005 [P] Create `lib/view_models/theme_cubit/theme_state.dart` — sealed `ThemeState` hierarchy
  - Create the directory `lib/view_models/theme_cubit/` if it does not exist.
  - Exact implementation required:
    ```dart
    part of 'theme_cubit.dart';

    sealed class ThemeState {
      const ThemeState();
    }

    final class ThemeLoaded extends ThemeState {
      const ThemeLoaded(this.themeMode);
      final ThemeMode themeMode;
    }
    ```
  - Use `part of 'theme_cubit.dart'` at the top (matches the existing cubit pattern in this project — e.g., see `lib/view_models/auth_cubit/auth_state.dart` for reference).

- [ ] T006 [P] Create `lib/view_models/theme_cubit/theme_cubit.dart` — `ThemeCubit` with `toggleTheme()`
  - Exact implementation required:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import '../../services/theme_services.dart';

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
    ```
  - The initial state is set from `initialIsDark` so the first frame renders the correct theme.

**Checkpoint**: All four files created and `flutter analyze` shows no errors → ready to start user stories.

---

## Phase 3: User Story 1 — Toggle Theme Instantly (Priority: P1) 🎯 MVP

**Goal**: A user opens the Profile page, taps the dark mode toggle, and the ENTIRE app switches theme instantly. No loading delay, no flash.

**Independent Test**: Navigate to the Profile tab → tap the toggle → verify ALL visible screens switch theme immediately. Tapping again returns to light mode.

### Tests for User Story 1 (Write FIRST — ensure they FAIL before implementing)

- [ ] T007 [P] [US1] Write unit tests for `ThemePreference` model in `test/models/theme_preference_test.dart`
  - Create directory `test/models/` if it does not exist.
  - Test cases to include:
    1. `ThemePreference.fromMap({'isDarkMode': true})` produces `isDarkMode == true`
    2. `ThemePreference.fromMap({'isDarkMode': false})` produces `isDarkMode == false`
    3. `ThemePreference.fromMap({})` produces `isDarkMode == false` (safe default)
    4. `ThemePreference(isDarkMode: true).toMap()` returns `{'isDarkMode': true}`
    5. `ThemePreference(isDarkMode: false).copyWith(isDarkMode: true)` returns `isDarkMode == true`
    6. Original instance is NOT mutated by `copyWith` (immutability)
  - Run `flutter test test/models/theme_preference_test.dart` and confirm it FAILS (class doesn't exist yet or tests fail).

- [ ] T008 [P] [US1] Write unit tests for `ThemeCubit` in `test/view_models/theme_cubit/theme_cubit_test.dart`
  - Create directory `test/view_models/theme_cubit/` if it does not exist.
  - Use `bloc_test` package (already a transitive dependency via `flutter_bloc`).
  - **DO NOT use `mocktail` or `mockito`** — Constitution IV requires cubits to be tested with real or fake service implementations, never with mocks that bypass the service contract. Instead, define a `FakeThemeServices` class at the top of the test file:
    ```dart
    class FakeThemeServices implements ThemeServices {
      bool? savedValue;
      @override
      Future<void> saveIsDarkMode(bool isDark) async {
        savedValue = isDark;
      }
    }
    ```
  - Test cases to include:
    1. Initial state is `ThemeLoaded(ThemeMode.light)` when `initialIsDark: false`
    2. Initial state is `ThemeLoaded(ThemeMode.dark)` when `initialIsDark: true`
    3. `toggleTheme()` when light mode → emits `ThemeLoaded(ThemeMode.dark)` and `fakeThemeServices.savedValue == true`
    4. `toggleTheme()` when dark mode → emits `ThemeLoaded(ThemeMode.light)` and `fakeThemeServices.savedValue == false`
    5. Rapid successive `toggleTheme()` calls → final state reflects the last toggle

- [ ] T009 [P] [US1] Write widget tests for `DarkModeToggleRow` in `test/views/widgets/dark_mode_toggle_row_test.dart`
  - Create directory `test/views/widgets/` if it does not exist.
  - Test cases to include:
    1. Widget renders a `Switch` widget
    2. When `isDarkMode == false`, `Switch.value` is `false` (light mode)
    3. When `isDarkMode == true`, `Switch.value` is `true` (dark mode)
    4. Tapping the switch calls the `onToggle` callback
    5. Widget has `Semantics` with `label == 'Dark mode'` and correct `toggled` value
    6. A moon icon is shown when dark mode is active; a sun icon when light mode is active

### Implementation for User Story 1

- [ ] T010 [P] [US1] Create `lib/views/widgets/dark_mode_toggle_row.dart` — the toggle row widget
  - This is a stateless widget that accepts the current theme state from `BlocBuilder<ThemeCubit, ThemeState>` and calls `context.read<ThemeCubit>().toggleTheme()` on toggle.
  - Exact implementation required:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import '../../view_models/theme_cubit/theme_cubit.dart';

    class DarkModeToggleRow extends StatelessWidget {
      const DarkModeToggleRow({super.key});

      @override
      Widget build(BuildContext context) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state is ThemeLoaded &&
                state.themeMode == ThemeMode.dark;
            return Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                const SizedBox(width: 12),
                const Text('Dark mode'),
                const Spacer(),
                Semantics(
                  label: 'Dark mode',
                  toggled: isDark,
                  child: Switch(
                    value: isDark,
                    onChanged: (_) =>
                        context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
    ```

- [ ] T011 [US1] Modify `lib/main.dart` to integrate `ThemeCubit` into the app
  - This task has two sub-changes in `main.dart`:

  **Sub-change A — `main()` function**: Make `main()` async, read `SharedPreferences` before `runApp()`, and pass `prefs` + `initialIsDark` to `MyApp`:
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

  **Sub-change B — `MyApp` widget**: Accept `prefs` and `initialIsDark`, add `ThemeCubit` to `MultiBlocProvider`, wrap the inner `BlocBuilder<AuthCubit>` tree with `BlocBuilder<ThemeCubit, ThemeState>`, and configure `MaterialApp` with both `theme`, `darkTheme`, and `themeMode`:
    ```dart
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
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.deepPurple),
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
  - Add the necessary imports at the top of `main.dart`:
    - `import 'package:shared_preferences/shared_preferences.dart';`
    - `import 'services/theme_services.dart';`
    - `import 'view_models/theme_cubit/theme_cubit.dart';`

- [ ] T012 [US1] Modify `lib/views/pages/profile_page.dart` to add `DarkModeToggleRow` above the logout button
  - Import the widget: `import '../widgets/dark_mode_toggle_row.dart';`
  - Locate the logout button widget in the file. Add `const DarkModeToggleRow()` as a widget immediately above it, with consistent padding/spacing matching the surrounding layout.
  - Do NOT change any other part of the profile page.

**Checkpoint**: At this point, US1 is fully functional:
- Run `flutter run`, navigate to Profile, tap the toggle → entire app switches theme instantly.
- Run `flutter test test/models/ test/view_models/ test/views/widgets/dark_mode_toggle_row_test.dart` → all tests pass.

---

## Phase 4: User Story 2 — Preference Persists Across Restarts (Priority: P2)

**Goal**: When the user enables dark mode and relaunches the app, dark mode is active from the very first frame — zero flash of wrong theme.

**Independent Test**: Enable dark mode → force-close the app → relaunch → verify dark mode is active immediately. Check that the Profile toggle shows the correct state.

> Note: The `main.dart` changes in T011 already implement the no-flash pattern (reading prefs before `runApp()`). Phase 4 adds the tests to verify and validate this behavior.

### Tests for User Story 2 (Write FIRST — ensure they FAIL before implementing)

- [ ] T013 [P] [US2] Write unit tests for `ThemeServicesImpl` in `test/services/theme_services_test.dart`
  - Create directory `test/services/` if it does not exist.
  - Use `shared_preferences` test fakes: call `SharedPreferences.setMockInitialValues({})` in `setUp`.
  - Test cases to include:
    1. `saveIsDarkMode(true)` writes `true` to key `dark_mode_enabled` in SharedPreferences
    2. `saveIsDarkMode(false)` writes `false` to key `dark_mode_enabled`
    3. After `saveIsDarkMode(true)`, reading `prefs.getBool('dark_mode_enabled')` returns `true`
    4. After `saveIsDarkMode(false)`, reading `prefs.getBool('dark_mode_enabled')` returns `false`
    5. `ThemeServicesImpl` only writes to SharedPreferences and makes zero network calls

- [ ] T014 [P] [US2] Write widget/integration test for the no-flash startup pattern in `test/views/pages/profile_page_dark_mode_test.dart`
  - Test cases to include:
    1. When `SharedPreferences` has `dark_mode_enabled = true`, `ThemeCubit` initial state is `ThemeLoaded(ThemeMode.dark)` — no intermediate light state is emitted
    2. When `SharedPreferences` has `dark_mode_enabled = false` (or key missing), `ThemeCubit` initial state is `ThemeLoaded(ThemeMode.light)`
    3. After calling `toggleTheme()`, SharedPreferences `dark_mode_enabled` key is updated to reflect the new state
    4. **FR-011**: When `SharedPreferences` has `dark_mode_enabled = false` AND the test widget tree uses `MediaQuery` with `platformBrightness: Brightness.dark`, the rendered `MaterialApp` `themeMode` is still `ThemeMode.light` — the device system theme MUST NOT influence the app theme

### Implementation for User Story 2

> The core persistence implementation was already done in T004 (`ThemeServicesImpl.saveIsDarkMode`) and T011 (`main()` reads prefs before `runApp()`). These tasks verify and ensure correctness.

- [ ] T015 [US2] Ensure `lib/main.dart` no-flash pattern is correct
  - If T011 was fully implemented, this task requires NO code changes — it is a mandatory verification checkpoint before proceeding to Phase 5.
  - Confirm that `main()` is `async` and calls `await SharedPreferences.getInstance()` BEFORE `runApp()`.
  - Confirm that `initialIsDark` is passed as a constructor argument to `MyApp` and ultimately to `ThemeCubit(initialIsDark: initialIsDark)`.
  - Confirm that `ThemeCubit` constructor uses `initialIsDark` to set `super(ThemeLoaded(...))` — NOT a loading state.
  - If any of the above is missing from T011, add the missing piece now (treated as a T011 continuation, not a new design decision).

- [ ] T016 [US2] Ensure edge case: corrupted or missing SharedPreferences value defaults to light mode
  - If T011 was fully implemented, this task requires NO code changes — it is a mandatory verification checkpoint.
  - In `lib/main.dart`, confirm the read uses the null-safe default: `prefs.getBool('dark_mode_enabled') ?? false`
  - The `?? false` ensures fresh installs (or cleared app data) start in light mode (FR-006).
  - If this default is missing, add it now (treated as a T011 continuation).

- [ ] T017 [US2] Run `flutter test test/services/ test/views/pages/profile_page_dark_mode_test.dart` and fix any failures
  - All 8 tests from T013 and T014 must pass.
  - If tests fail due to implementation issues (not test issues), fix the implementation.

**Checkpoint**: At this point, US2 is fully verified:
- Enable dark mode → force-close (or hot restart is not sufficient; use a real relaunch or integration test) → dark mode is active from frame 1.
- All T013 + T014 tests pass.

---

## Phase 5: User Story 3 — Consistent Dark Visuals Across All Screens (Priority: P3)

**Goal**: When dark mode is active, EVERY screen and widget renders with dark backgrounds, light text, and adapted colors. No white/light backgrounds visible anywhere.

**Independent Test**: Enable dark mode → navigate to every screen listed below → verify no white/light backgrounds appear on any screen.

**IMPORTANT**: Use the Color Migration Reference table at the top of this file for every replacement. Do NOT change `Colors.green`, `Colors.red`, or `Colors.blue` — these are semantic colors that remain fixed.

**IMPORTANT**: Do NOT remove or alter product images, carousel banners, or user avatars (FR-009). Only background, text, card, and border colors change.

### Test for User Story 3 (Write FIRST)

- [ ] T018 [P] [US3] Write widget test verifying dark background on `home_page` with FR-009/FR-010 assertions in `test/views/pages/home_page_dark_test.dart`
  - Wrap `HomePage` in a `BlocProvider<ThemeCubit>` with `initialIsDark: true` and a `MaterialApp` configured with `darkTheme` and `themeMode: ThemeMode.dark`.
  - Verify there are NO `Scaffold` widgets with `backgroundColor: Colors.white` or literal white backgrounds.
  - Verify `Theme.of(context).brightness == Brightness.dark`.
  - **FR-009**: Find any `Image` or `CachedNetworkImage` widgets in the tree and assert they have no `color` filter and `colorBlendMode` is null — images must not be tinted or filtered by the theme change.
  - **FR-010**: Assert `Theme.of(context).colorScheme.primary` is not `Colors.black` and not `Colors.white` — the brand deep-purple must remain recognizable in dark mode.

- [ ] T046 [P] [US3] Write widget dark mode tests for login, cart, profile, and product-details pages (SC-003 coverage)
  - **SC-003 requires 100% of app screens to render correctly in dark mode.** T018 covers home_page. This task covers the next four highest-risk screens.
  - For each screen below, create a test file using the same harness as T018 (BlocProvider<ThemeCubit> + MaterialApp with darkTheme/ThemeMode.dark) and assert `Theme.of(context).brightness == Brightness.dark` with no white/light scaffold backgrounds:
    1. `test/views/pages/login_page_dark_test.dart` — `LoginPage`
    2. `test/views/pages/cart_page_dark_test.dart` — `CartPage`
    3. `test/views/pages/product_details_dark_test.dart` — `ProductDetailsPage`
    4. `test/views/pages/profile_page_dark_test.dart` — `ProfilePage` (if T014 does not already cover this)
  - The remaining screens (Favorites, Checkout, ChooseLocation, AddNewCard, Register, BottomNavBar) are verified by the manual checklist in T045.

### Implementation for User Story 3

> All migration tasks below are marked [P] — they are in independent files with no cross-dependencies. They can be implemented in parallel.

**Utils and Models**

- [ ] T019 [P] [US3] Update `lib/utils/app_colors.dart` — document theme-independent constants
  - Review all color constants in this file.
  - Add a comment `// theme-independent` next to colors that should NOT be replaced by theme references (green for success, red for error, blue for links, deepPurple as brand primary).
  - If `AppColors.white` or `AppColors.black` are used by any page/widget, mark them as deprecated with a comment: `// deprecated: use Theme.of(context).colorScheme.surface instead`.
  - Do NOT remove any constants — only add documentation comments.

- [ ] T020 [P] [US3] Audit `lib/models/category_model.dart` for hardcoded `Colors.*`
  - Run `grep "Colors\." lib/models/category_model.dart` to check for any color usages.
  - **If the grep returns zero results**: this file needs no changes — mark T020 complete with no edits.
  - **If `Colors.*` references are found**: models must not contain UI/widget color logic (Constitution III). For each occurrence: if the color is used as a display property (background, text color), move it to the widget that renders it and pass it as a constructor parameter to the model if truly needed; do NOT call `Theme.of(context)` inside a model class. After any changes, run `flutter analyze lib/models/category_model.dart` — must report 0 errors.

**Pages (10 files)**

- [ ] T021 [P] [US3] Migrate `lib/views/pages/home_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/home_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - Remove any explicit `scaffoldBackgroundColor: Colors.white` — let `ThemeData` manage it.
  - After migration, run `flutter analyze lib/views/pages/home_page.dart` — must report 0 errors.

- [ ] T022 [P] [US3] Migrate `lib/views/pages/cart_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/cart_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/cart_page.dart` — must report 0 errors.

- [ ] T023 [P] [US3] Migrate `lib/views/pages/favorites_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/favorites_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/favorites_page.dart` — must report 0 errors.

- [ ] T024 [P] [US3] Migrate `lib/views/pages/product_details_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/product_details_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/product_details_page.dart` — must report 0 errors.

- [ ] T025 [P] [US3] Migrate `lib/views/pages/checkout_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/checkout_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/checkout_page.dart` — must report 0 errors.

- [ ] T026 [P] [US3] Migrate `lib/views/pages/choose_location_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/choose_location_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/choose_location_page.dart` — must report 0 errors.

- [ ] T027 [P] [US3] Migrate `lib/views/pages/add_new_card_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/add_new_card_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/add_new_card_page.dart` — must report 0 errors.

- [ ] T028 [P] [US3] Migrate `lib/views/pages/login_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/login_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/login_page.dart` — must report 0 errors.

- [ ] T029 [P] [US3] Migrate `lib/views/pages/register_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/register_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/register_page.dart` — must report 0 errors.

- [ ] T030 [P] [US3] Migrate `lib/views/pages/custom_bottom_navbar.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/pages/custom_bottom_navbar.dart` to identify all usages.
  - Pay special attention to icon colors and background of the bottom navigation bar — they must adapt to dark mode.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/pages/custom_bottom_navbar.dart` — must report 0 errors.

- [ ] T047 [P] [US3] Migrate `lib/views/pages/profile_page.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - T012 adds the `DarkModeToggleRow` widget to this page. This task handles the page's existing hardcoded color references independently.
  - Run `grep -n "Colors\." lib/views/pages/profile_page.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - Do NOT touch the `DarkModeToggleRow` insertion point added by T012.
  - After migration, run `flutter analyze lib/views/pages/profile_page.dart` — must report 0 errors.

**Widgets (12 files)**

- [ ] T031 [P] [US3] Migrate `lib/views/widgets/cart_item_widget.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/cart_item_widget.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/cart_item_widget.dart` — must report 0 errors.

- [ ] T032 [P] [US3] Migrate `lib/views/widgets/product_item.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/product_item.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/product_item.dart` — must report 0 errors.

- [ ] T033 [P] [US3] Migrate `lib/views/widgets/main_button.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/main_button.dart` to identify all usages.
  - The primary button color (`Colors.deepPurple`) should become `Theme.of(context).colorScheme.primary`.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/main_button.dart` — must report 0 errors.

- [ ] T034 [P] [US3] Migrate `lib/views/widgets/home_tab_view.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/home_tab_view.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/home_tab_view.dart` — must report 0 errors.

- [ ] T035 [P] [US3] Migrate `lib/views/widgets/social_media_button.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/social_media_button.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/social_media_button.dart` — must report 0 errors.

- [ ] T036 [P] [US3] Migrate `lib/views/widgets/empty_shipping_payment.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/empty_shipping_payment.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/empty_shipping_payment.dart` — must report 0 errors.

- [ ] T037 [P] [US3] Migrate `lib/views/widgets/payment_method_item.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/payment_method_item.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/payment_method_item.dart` — must report 0 errors.

- [ ] T038 [P] [US3] Migrate `lib/views/widgets/label_with_value_row.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/label_with_value_row.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/label_with_value_row.dart` — must report 0 errors.

- [ ] T039 [P] [US3] Migrate `lib/views/widgets/payment_method_bottom_sheet.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/payment_method_bottom_sheet.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/payment_method_bottom_sheet.dart` — must report 0 errors.

- [ ] T040 [P] [US3] Migrate `lib/views/widgets/counter_widget.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/counter_widget.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/counter_widget.dart` — must report 0 errors.

- [ ] T041 [P] [US3] Migrate `lib/views/widgets/label_with_textfield.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/label_with_textfield.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/label_with_textfield.dart` — must report 0 errors.

- [ ] T042 [P] [US3] Migrate `lib/views/widgets/location_item_widget.dart` — replace hardcoded `Colors.*` with `Theme.of(context).colorScheme.*`
  - Run `grep -n "Colors\." lib/views/widgets/location_item_widget.dart` to identify all usages.
  - Apply the Color Migration Reference table for each occurrence.
  - After migration, run `flutter analyze lib/views/widgets/location_item_widget.dart` — must report 0 errors.

**Checkpoint**: At this point, US3 is complete:
- Enable dark mode → navigate to all 10 screens listed in the spec → no white/light backgrounds visible anywhere.
- Run `flutter test test/views/pages/home_page_dark_test.dart` → passes.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final verification, coverage check, and static analysis across all changes.

- [ ] T043 Run `flutter analyze` from repo root and fix ALL warnings and errors
  - Execute: `flutter analyze`
  - Zero issues must be reported before marking this complete.
  - Pay special attention to unused imports left over from color migration.

- [ ] T044 Run `flutter test --coverage` and verify coverage meets the 80% minimum
  - Execute: `flutter test --coverage`
  - Check coverage for: `lib/models/theme_preference.dart`, `lib/services/theme_services.dart`, `lib/view_models/theme_cubit/theme_cubit.dart`, `lib/views/widgets/dark_mode_toggle_row.dart`
  - If coverage is below 80% for any of these files, add additional tests to bring it up.

- [ ] T045 [P] Run the manual verification checklist from `specs/001-dark-mode-toggle/quickstart.md`
  - Launch the app on a real device or emulator (`flutter run`).
  - Walk through each item in the "Manual Verification Checklist" in `specs/001-dark-mode-toggle/quickstart.md`.
  - **SC-004 (WCAG AA contrast)**: While in dark mode, use a contrast checker tool (e.g., the Flutter DevTools accessibility inspector, or a color picker + contrast calculator) to spot-check the following against the dark theme background:
    - Body text: must meet 4.5:1 contrast ratio (WCAG AA normal text)
    - Large text (≥ 18pt or ≥ 14pt bold) and icons: must meet 3:1
    - Check at minimum: product card text on Home, input field labels on Login, body text on Profile
  - Report any failing contrast values as bugs to fix (adjust the dark `ColorScheme` seed or override specific colors in `ThemeData`).
  - All checklist items must pass. Report any failures before closing the feature.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 completion — BLOCKS all user stories.
- **US1 (Phase 3)**: Depends on Phase 2 — T007–T009 (tests) can run as soon as models/services/cubits are created but will fail until T003–T006 are done. T010–T012 depend on T003–T006.
- **US2 (Phase 4)**: Depends on Phase 3 (T011 must be done — `main.dart` already reads prefs).
- **US3 (Phase 5)**: Depends on Phase 3 (T011 must be done — `MaterialApp` must have `darkTheme` + `themeMode` wired before migration has visible effect).
- **Polish (Phase 6)**: Depends on all previous phases.

### User Story Dependencies

- **US1 (P1)**: Implement first. Blocks US2 (verification) and US3 (migration has no visual effect without the BlocBuilder).
- **US2 (P2)**: Can be worked in parallel with US3 after US1 is complete.
- **US3 (P3)**: Can be worked in parallel with US2 after US1 is complete. Each file migration is independent.

### Within Each User Story

- Tests MUST be written and FAIL before implementation begins.
- Model files before service files.
- Service files before cubit files.
- Cubit files before widget files.
- Widgets before page modifications.

### Parallel Opportunities

- T003, T004, T005, T006 (Phase 2): Can all run in parallel — different files.
- T007, T008, T009, T010 (Phase 3 tests + DarkModeToggleRow): Can run in parallel.
- T013, T014 (Phase 4 tests): Can run in parallel.
- T019–T042 (Phase 5 migrations): ALL can run in parallel — 24 independent files.

---

## Parallel Example: Phase 5 (US3 Color Migrations)

All 24 migration tasks can be implemented simultaneously by parallel agents:

```
Agent 1: T021 home_page.dart + T022 cart_page.dart
Agent 2: T023 favorites_page.dart + T024 product_details_page.dart
Agent 3: T025 checkout_page.dart + T026 choose_location_page.dart
Agent 4: T027 add_new_card_page.dart + T028 login_page.dart
Agent 5: T029 register_page.dart + T030 custom_bottom_navbar.dart
Agent 6: T031 cart_item_widget.dart + T032 product_item.dart
Agent 7: T033 main_button.dart + T034 home_tab_view.dart + T035 social_media_button.dart
Agent 8: T036–T042 remaining widgets
```

---

## Implementation Strategy

### MVP First (US1 Only — ~1 hour of work)

1. Complete Phase 1: Setup (T001–T002)
2. Complete Phase 2: Foundational (T003–T006) in parallel
3. Complete Phase 3: US1 (T007–T012) — write tests first!
4. **STOP and VALIDATE**: Toggle works, theme switches instantly.
5. Demo to stakeholder if needed.

### Incremental Delivery

1. Phase 1 + Phase 2 → Theme layer ready (no visible change)
2. Phase 3 → Toggle works + persists (US1 + foundation for US2)
3. Phase 4 → Persistence verified with tests (US2)
4. Phase 5 → Full dark theme coverage (US3) — the most parallelizable phase
5. Phase 6 → Polish and coverage verification

---

## Summary

| Phase | Tasks | Story | Parallel? |
|-------|-------|-------|-----------|
| Phase 1: Setup | T001–T002 | — | No |
| Phase 2: Foundational | T003–T006 | — | Yes (all 4) |
| Phase 3: US1 | T007–T012 | US1 | Partial |
| Phase 4: US2 | T013–T017 | US2 | Partial |
| Phase 5: US3 | T018–T042, T046–T047 | US3 | Yes (all migrations + screen tests) |
| Phase 6: Polish | T043–T045 | — | Partial |
| **Total** | **47 tasks** | | |

**US1 task count**: 6 (T007–T012)
**US2 task count**: 5 (T013–T017)
**US3 task count**: 27 (T018–T042, T046–T047)
**Parallel opportunities**: 35 tasks marked [P]
**Suggested MVP scope**: Phase 1 + Phase 2 + Phase 3 (US1 only) = 12 tasks
