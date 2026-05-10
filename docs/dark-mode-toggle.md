# Dark Mode Toggle

## What We're Building

Add a dark mode toggle to our Flutter e-commerce app. Users should be able to switch between light and dark themes from the Profile page. The preference should persist across app restarts using local storage only — no Firebase or backend changes.

## Why

Dark mode is one of the most requested features in mobile apps. It reduces eye strain in low-light environments, saves battery on OLED screens, and gives the app a modern, polished feel. For our e-commerce app, it also makes product images pop against dark backgrounds.

## Current State of the App

- The app uses a centralized `AppColors` class with hardcoded light colors (deep purple primary, white backgrounds, grey shades).
- `MaterialApp` defines a single `ThemeData` using `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` with Material 3 enabled.
- State management is handled via `flutter_bloc` (Cubits). Global cubits (`AuthCubit`, `FavoriteCubit`) are provided at the root `MultiBlocProvider` in `main.dart`.
- The Profile page currently only has a logout button — there's room to add the toggle there.
- The app has 8+ screens: Home (with carousel + product grid + category tabs), Cart, Favorites, Product Details, Checkout, Choose Location, Add New Card, Login, Register, and a Profile page.
- Some widgets use hardcoded colors directly (e.g., `Colors.white`, `AppColors.grey1`) instead of theme-aware references.
- Bottom navigation uses `persistent_bottom_nav_bar_v2`.

## Who Uses It

All app users. There are no roles or permissions involved — every user sees the same toggle and can switch freely.

## User Flows

1. **Toggle the theme**: User opens Profile page → sees a dark mode switch → taps it → the entire app instantly switches to dark mode (or back to light mode).
2. **Persistence**: User enables dark mode → closes the app → reopens → app starts in dark mode with no flash of light theme.
3. **First launch**: Fresh install → no stored preference → app defaults to light mode.

## What Should Change in Dark Mode

- Scaffold backgrounds → dark surface color
- App bars → dark surface with light text/icons
- Bottom navigation bar → dark background with adapted icon colors
- Cards (product cards, cart items, checkout sections) → dark elevated surface
- Text → light color on dark backgrounds
- Input fields → dark fill with light text and visible borders
- Buttons → primary color adapted for dark backgrounds
- Dialogs and snackbars → dark surfaces
- Status bar → light icons on dark background
- Dividers and borders → subtle light-on-dark variants

## What Should NOT Change

- Product images, carousel banners, user avatars → these stay as-is
- The primary brand color (deep purple) → stays recognizable, just adapted for contrast
- App logic, navigation, data flow → zero functional changes

## Constraints

- **No backend**: Zero Firebase, Firestore, or network calls. Theme preference is stored locally only (e.g., `shared_preferences`).
- **No new packages** beyond what's needed for local storage (if `shared_preferences` isn't already in the project, it can be added).
- **No system theme following**: The in-app toggle is the sole control. We don't read the device's system dark mode setting.
- **Instant switching**: No loading spinners or delays when toggling. The rebuild should feel immediate.
- **No startup flash**: The stored preference must be loaded before the first frame renders so the user never sees a flash of the wrong theme.

## Scope Boundaries

### In Scope

- Dark mode and light mode theme definitions
- A `ThemeCubit` (or equivalent) for managing theme state
- A toggle switch on the Profile page with a clear icon (sun/moon)
- Local persistence of the theme preference
- Updating all existing screens and widgets to be theme-aware
- Adapting `AppColors` or replacing hardcoded colors with theme-aware references

### Out of Scope

### Out of Scope

- Scheduled/automatic dark mode (e.g., based on time of day)
- Per-screen theme overrides
- Custom theme colors beyond light/dark (no "blue theme", "green theme", etc.)
- Animated theme transitions (e.g., circular reveal animation)
- Following the device system theme setting

## Technical Hints (for planning phase)

- The theme Cubit should be added to the root `MultiBlocProvider` in `main.dart` alongside `AuthCubit` and `FavoriteCubit`.
- `shared_preferences` can store a simple boolean (`isDarkMode`).
- `MaterialApp`'s `theme` and `darkTheme` properties combined with `themeMode` provide native support for this.
- Widgets currently using `AppColors.white` or `Colors.grey.shade100` as backgrounds will need to switch to `Theme.of(context).scaffoldBackgroundColor` or `Theme.of(context).colorScheme.surface`.
- The `BlocBuilder<ThemeCubit, ThemeState>` should wrap the `MaterialApp` widget so theme changes trigger a full rebuild.

## Expected Result

After implementation, the user taps a single toggle on the Profile page and the entire app — every screen, every card, every button — transforms between a clean light theme and a polished dark theme. The preference sticks across restarts. It looks professional, feels instant, and requires zero backend work.
