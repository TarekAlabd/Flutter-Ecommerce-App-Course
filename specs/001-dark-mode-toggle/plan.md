# Implementation Plan: Dark Mode Toggle

**Branch**: `001-dark-mode-toggle` | **Date**: 2026-05-10 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/001-dark-mode-toggle/spec.md`

## Summary

Implement a persistent dark mode toggle on the Profile page using a global `ThemeCubit` backed by `shared_preferences`. The stored preference is read in `main()` before `runApp()` to eliminate any flash of the wrong theme. All 10+ app screens are migrated from hardcoded `Colors.*` references to theme-aware `Theme.of(context)` lookups.

## Technical Context

**Language/Version**: Dart/Flutter SDK ≥ 3.0.2 <4.0.0
**Primary Dependencies**:
- `flutter_bloc ^8.1.6` (existing)
- `shared_preferences ^2.5.5` (NEW — local key-value persistence)

**Storage**: SharedPreferences; single key `dark_mode_enabled` (bool, default `false`)
**Testing**: flutter_test — unit tests (model, service, cubit), widget tests (toggle row), integration test (toggle + restart flow)
**Target Platform**: Android & iOS
**Project Type**: Mobile app
**Performance Goals**: Theme switch < 1 second (SC-001); zero flash of wrong theme on relaunch (SC-002)
**Constraints**: Zero network calls for theme operations; no Firebase/backend involvement (FR-012); offline-capable
**Scale/Scope**: 10+ screens, ~20 widget/page files require hardcoded color migration

## Constitution Check

*GATE: Must pass before implementation. Re-checked after Phase 1 design.*

- [x] **I. MVVM + BLoC**: Adapted flow: `SharedPreferences → ThemeServices → ThemeCubit → View`. Firestore is not involved in this feature. Unidirectional flow and layer separation are preserved. No business logic in widgets.
- [x] **II. Service Abstraction**: `ThemeServices` abstract class + `ThemeServicesImpl` wrapping `SharedPreferences`. Cubit declares the dependency as the abstract type. No direct SharedPreferences access outside the service.
- [x] **III. Immutable Models**: `ThemePreference(isDarkMode: bool)` — all fields `final`, implements `fromMap`, `toMap`, `copyWith`. No in-place mutation.
- [x] **IV. Test-First**: Tests written before implementation. Coverage target ≥ 80%. Unit tests for model/service/cubit, widget test for toggle row, integration test for persist-and-reload flow.
- [x] **V. State via Cubit**: `ThemeCubit` is global (app-wide state), added to root `MultiBlocProvider` in `main.dart` alongside `AuthCubit` and `FavoriteCubit`. Sealed state hierarchy: `ThemeLoaded(ThemeMode)`. No `setState` for theme state.
- [x] **VI. Clean Navigation**: No new routes. The toggle lives on the existing Profile page (already routed). N/A for route registration.
- [x] **VII. Firebase Best Practices**: This feature has zero Firebase involvement (FR-012). N/A.

## Project Structure

### Documentation (this feature)

```text
specs/001-dark-mode-toggle/
├── plan.md              ← this file
├── research.md          ← Phase 0 output
├── data-model.md        ← Phase 1 output
├── quickstart.md        ← Phase 1 output
└── tasks.md             ← Phase 2 output (/speckit-tasks — not yet created)
```

### Source Code

```text
lib/
├── models/
│   └── theme_preference.dart               [NEW]
├── services/
│   └── theme_services.dart                 [NEW]
├── view_models/
│   └── theme_cubit/
│       ├── theme_cubit.dart                [NEW]
│       └── theme_state.dart                [NEW]
├── views/
│   ├── pages/
│   │   ├── profile_page.dart               [MODIFIED — adds DarkModeToggleRow above logout]
│   │   ├── home_page.dart                  [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── cart_page.dart                  [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── favorites_page.dart             [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── product_details_page.dart       [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── checkout_page.dart              [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── choose_location_page.dart       [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── add_new_card_page.dart          [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── login_page.dart                 [MODIFIED — hardcoded Colors → Theme.of()]
│   │   ├── register_page.dart              [MODIFIED — hardcoded Colors → Theme.of()]
│   │   └── custom_bottom_navbar.dart       [MODIFIED — hardcoded Colors → Theme.of()]
│   └── widgets/
│       ├── dark_mode_toggle_row.dart       [NEW]
│       ├── cart_item_widget.dart           [MODIFIED]
│       ├── product_item.dart               [MODIFIED]
│       ├── main_button.dart                [MODIFIED]
│       └── [other widgets as needed]       [MODIFIED]
├── utils/
│   └── app_colors.dart                     [MODIFIED — dark theme constants]
└── main.dart                               [MODIFIED — read prefs, inject ThemeCubit, wrap MaterialApp]

test/
├── models/
│   └── theme_preference_test.dart          [NEW]
├── services/
│   └── theme_services_test.dart            [NEW]
└── view_models/
    └── theme_cubit/
        └── theme_cubit_test.dart           [NEW]
```

**Structure Decision**: Single Flutter project. Theme layer files follow the same pattern as all other features (`models/`, `services/`, `view_models/`). Theme state is global (like `AuthCubit`) because it spans all screens.

## Complexity Tracking

> Constitution Check passed — no violations. One deliberate design note documented below.

| Design Note | Why Needed | Alternative Rejected Because |
|-------------|------------|------------------------------|
| SharedPreferences read happens in `main()` directly (not via `ThemeServices`) | Must read before `runApp()` to set `ThemeCubit` initial state synchronously — prevents flash of wrong theme (SC-002). No loading state is ever emitted. | Exposing `readIsDarkMode()` on `ThemeServices` would require the same `await` in `main()` with no testability benefit; tests use `SharedPreferences.setMockInitialValues` to control the initial value regardless. |
