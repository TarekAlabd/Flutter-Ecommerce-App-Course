---
description: "Use when writing or modifying Dart/Flutter files. Covers project-specific patterns for models, services, cubits, views, and routing."
applyTo: "lib/**/*.dart"
---

# Flutter E-Commerce Conventions

See [AGENTS.md](../../AGENTS.md) for full architecture details.

## Data Flow

Firestore → Service (`*Impl`) → Cubit → View. Never access Firestore directly from views or cubits.

## Models

- Immutable with `fromMap(Map<String, dynamic>)`, `toMap()`, and `copyWith()`
- Use `final` fields only; update state via `copyWith()`

## Services

- Define an abstract class first, then a concrete `*Impl`:
  ```dart
  abstract class CartServices { ... }
  class CartServicesImpl implements CartServices { ... }
  ```
- Access Firestore exclusively through `FirestoreServices.instance`
- Build all paths via `ApiPaths` static methods — never hardcode collection names

## Cubits

- One cubit per feature: `*_cubit.dart` + `*_state.dart` linked with `part`/`part of`
- Use `sealed class` for state hierarchy
- Instantiate services directly in the cubit (no DI container)

## Routing

- Add route name constants in `lib/utils/app_routes.dart`
- Add route builder case in `AppRouter.onGenerateRoute` (`lib/utils/app_router.dart`)
- Wrap route-scoped cubits with `BlocProvider` inside the route builder
- Global cubits (`AuthCubit`, `FavoriteCubit`) are provided at root in `main.dart`

## Validation Checklist

Run before committing:

```bash
flutter analyze && flutter test
```
