# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run on connected device/emulator
flutter analyze          # Static analysis (uses flutter_lints)
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter build apk        # Build Android release
flutter build ios        # Build iOS release
```

## Architecture

This is a Flutter e-commerce app using **MVVM + BLoC/Cubit**. Data flows: Firestore → Service → Cubit → View.

### Layer breakdown

| Directory | Role |
|-----------|------|
| `lib/models/` | Immutable data models with `fromMap`, `toMap`, `copyWith` |
| `lib/services/` | Abstract interface + concrete `Impl` class per domain (Firestore access only) |
| `lib/view_models/` | One Cubit per feature, split into `*_cubit.dart` + `*_state.dart` using `part`/`part of` |
| `lib/views/pages/` | Full-screen pages — each gets its own BlocProvider via `AppRouter` |
| `lib/views/widgets/` | Reusable widgets, receive data via constructor |
| `lib/utils/` | `AppRouter` (route factory), `AppRoutes` (route name constants), `ApiPaths` (Firestore path helpers), `AppColors` |

### Key patterns

**Services** always declare an abstract class first (`AuthServices`, `HomeServices`, etc.), then a concrete `*Impl`. Cubits instantiate the `Impl` directly — no DI container.

**Firestore access** goes through the `FirestoreServices` singleton (`FirestoreServices.instance`). It exposes generic methods: `setData`, `deleteData`, `collectionStream`, `documentStream`, `getDocument`, `getCollection`. All Firestore paths are built via `ApiPaths` static methods.

**Routing** uses named routes with `AppRouter.onGenerateRoute`. Cubits that require constructor arguments (e.g., `ProductDetailsCubit`, `ChooseLocationCubit`) are created inside the route builder and wrapped with `BlocProvider`. The `PaymentMethodsCubit` is passed as a route argument and re-provided with `BlocProvider.value`.

**Global cubits** — `AuthCubit` and `FavoriteCubit` — are provided at the root `MultiBlocProvider` in `main.dart`. All other cubits are scoped to their route.

**FCM** is initialized in `main.dart` before `runApp`. A global `navigatorKey` is used to show dialogs and navigate from notification callbacks.

### Firebase collections (Firestore)

- `products/` — product catalog
- `announcements/` — home carousel banners
- `categories/` — product categories
- `users/{userId}/cart/` — cart items
- `users/{userId}/favorites/` — favorited products
- `users/{userId}/locations/` — saved delivery addresses
- `users/{userId}/paymentCards/` — saved payment methods

### Authentication

Supports email/password, Google Sign-In, and Facebook Login — all via `AuthServicesImpl`. After registration, user data is persisted to `users/{uid}` in Firestore.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at `specs/001-dark-mode-toggle/plan.md`.
<!-- SPECKIT END -->
