# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter e-commerce app using MVVM with BLoC/Cubit. Source code lives in `lib/`:

- `lib/models/`: data models with mapping and copy helpers.
- `lib/services/`: Firebase/Auth/Firestore service interfaces and implementations.
- `lib/view_models/`: feature Cubits and states, typically `*_cubit.dart` plus `*_state.dart`.
- `lib/views/pages/`: route-level screens.
- `lib/views/widgets/`: reusable UI widgets.
- `lib/utils/`: routing, colors, route names, and Firestore path helpers.

Tests live in `test/`. Static assets are under `assets/`, currently `assets/images/`, and must be declared in `pubspec.yaml`. Platform folders (`android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`) contain generated and platform-specific Flutter project files.

## Build, Test, and Development Commands

- `flutter pub get`: install package dependencies.
- `flutter run`: run the app on a connected device or emulator.
- `flutter analyze`: run Dart analyzer using `flutter_lints`.
- `flutter test`: run the full test suite.
- `flutter test test/widget_test.dart`: run one test file.
- `flutter build apk`: create an Android release build.
- `flutter build ios`: create an iOS release build on macOS with Xcode.

## Coding Style & Naming Conventions

Use the standard Dart formatter: `dart format .`. Follow `analysis_options.yaml`, which includes `package:flutter_lints/flutter.yaml`. Use two-space indentation and prefer idiomatic Flutter composition over large build methods.

Use `snake_case.dart` file names. Keep Cubit files named by feature, such as `cart_cubit.dart` and `cart_state.dart`. Use `PascalCase` for classes, `camelCase` for fields and methods, and route constants through `AppRoutes`.

## Testing Guidelines

Use `flutter_test` for widget and unit tests. Place tests in `test/` and name files `*_test.dart`. Add focused tests for Cubit behavior, service mapping logic, and critical checkout/auth flows when changing those areas. Run `flutter test` and `flutter analyze` before opening a PR.

## Commit & Pull Request Guidelines

Recent commits use Conventional Commit-style prefixes with linked PR numbers, for example `feat: add fcm (#59)`. Prefer `feat:`, `fix:`, `refactor:`, or `test:` followed by a concise imperative summary.

PRs should include a short description, linked issue when applicable, screenshots or screen recordings for UI changes, and notes about Firebase/configuration changes. Mention which commands were run, especially `flutter analyze` and `flutter test`.

## Security & Configuration Tips

Do not commit secrets, private API keys, or local Firebase credentials. Keep Firebase paths centralized in `ApiPaths`, and route Firestore access through `FirestoreServices.instance` instead of embedding collection names directly in UI code.
