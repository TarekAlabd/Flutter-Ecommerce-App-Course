<!--
SYNC IMPACT REPORT
==================
Version change: [unversioned template] → 1.0.0
Modified principles: N/A (initial population from template)
Added sections:
  - I. MVVM + BLoC Architecture (NON-NEGOTIABLE)
  - II. Service Abstraction Layer
  - III. Immutable Data Models
  - IV. Test-First Development (NON-NEGOTIABLE)
  - V. State via Cubit Only
  - VI. Clean Navigation & Scoped Providers
  - VII. Firebase Best Practices
  - Technology Standards
  - Development Workflow & Quality Gates
  - Governance
Removed sections: None (template placeholders replaced)
Templates requiring updates:
  ✅ .specify/templates/constitution-template.md — source, no changes needed
  ✅ .specify/templates/plan-template.md — Constitution Check section aligns with principles above
  ✅ .specify/templates/spec-template.md — no structural changes required
  ✅ .specify/templates/tasks-template.md — path conventions updated to Flutter conventions (lib/, test/)
Follow-up TODOs:
  - RATIFICATION_DATE set to 2026-05-10 (initial creation)
-->

# Flutter E-commerce App Constitution

## Core Principles

### I. MVVM + BLoC Architecture (NON-NEGOTIABLE)

All features MUST follow the strict unidirectional data flow:
**Firestore → Service → Cubit → View**

- Views MUST be passive: they render state and emit events — no business logic allowed in widgets.
- Cubits own all business logic and coordinate with services; they MUST NOT hold UI references.
- Models live in `lib/models/`, services in `lib/services/`, cubits in `lib/view_models/`, UI in `lib/views/`.
- File size limits: pages ≤ 400 lines, cubits ≤ 300 lines, services ≤ 200 lines.

**Rationale**: Layered separation enables parallel testing of each layer and prevents UI logic drift. Violation creates untestable god-widgets and tangled state.

### II. Service Abstraction Layer

Every data domain MUST expose an abstract class (e.g., `AuthServices`) before any concrete implementation (`AuthServicesImpl`).

- The abstract class declares the contract; the `Impl` satisfies it.
- Cubits MUST depend on the abstract type at construction time (even if they instantiate the `Impl` directly — no DI container is required, but the type MUST be declared as the interface).
- Direct Firestore calls from outside a Service class are FORBIDDEN. All Firestore access goes through `FirestoreServices.instance`.
- All Firestore collection and document paths MUST be declared as static methods in `ApiPaths`.

**Rationale**: The abstract boundary allows swapping real services for fakes in tests without touching cubit or view code.

### III. Immutable Data Models

All data models in `lib/models/` MUST be immutable.

- Every model MUST implement: `fromMap(Map<String, dynamic>)` factory, `toMap()` method, and `copyWith(...)` method.
- Fields MUST be declared `final`. Mutation is NEVER performed in-place — return a new instance via `copyWith`.
- Models MUST NOT contain business logic; they are pure data carriers.
- `fromMap` MUST provide safe defaults or throw a descriptive error — silent `null` coercion is forbidden.

**Rationale**: Immutable models prevent hidden side-effects across BLoC boundaries, make equality checks trivial, and eliminate a class of state bugs.

### IV. Test-First Development (NON-NEGOTIABLE)

Tests MUST be written before implementation code. The Red-Green-Refactor cycle is strictly enforced.

- **Red**: Write a failing test that captures the requirement.
- **Green**: Write the minimal implementation to make the test pass.
- **Refactor**: Clean up without breaking tests.
- Minimum coverage gate: **80%** across all layers (models, services, cubits).
- Test types REQUIRED: unit tests (models, cubits, services), widget tests (critical widgets), integration tests (end-to-end user flows).
- Tests live in `test/` mirroring `lib/` structure. Example: `lib/view_models/auth_cubit/auth_cubit.dart` → `test/view_models/auth_cubit/auth_cubit_test.dart`.
- Cubits MUST be tested with real or fake service implementations — never with Mockito mocks that bypass the service contract.

**Rationale**: Test-first catches design flaws early, documents intent, and provides a regression safety net for a rapidly evolving feature set.

### V. State via Cubit Only

All reactive UI state MUST flow through a Cubit. Direct `setState` usage is FORBIDDEN except in purely local, ephemeral UI state (e.g., a text field focus toggle with no business meaning).

- Global cubits (currently `AuthCubit`, `FavoriteCubit`) are provided at the root `MultiBlocProvider` in `main.dart` and MUST remain there.
- Feature cubits are scoped to their route via `BlocProvider` inside `AppRouter.onGenerateRoute`. They MUST NOT be elevated to global scope unless the state is genuinely app-wide.
- Each Cubit file (`*_cubit.dart`) MUST use `part`/`part of` to pair with its state file (`*_state.dart`).
- States MUST be sealed class hierarchies (or `abstract` base + concrete subclasses) — no boolean flag soup.

**Rationale**: Centralised state flow enables time-travel debugging, predictable rebuild scopes, and isolated unit testing of state transitions.

### VI. Clean Navigation & Scoped Providers

All navigation MUST use named routes declared in `AppRoutes` and resolved in `AppRouter.onGenerateRoute`.

- Route constants live exclusively in `AppRoutes`. Hard-coded route strings elsewhere are FORBIDDEN.
- Cubits that require constructor arguments MUST be created inside the route builder and wrapped with `BlocProvider`.
- Cubits passed as route arguments (e.g., `PaymentMethodsCubit`) MUST be re-provided via `BlocProvider.value` — never accessed via `BlocProvider.of` without a proper ancestor provider.
- Deep-link and notification navigation MUST route through `AppRouter` via the global `navigatorKey`.

**Rationale**: Centralised routing makes navigation auditable, keeps cubit lifetimes predictable, and ensures no stale state leaks across routes.

### VII. Firebase Best Practices

Firebase usage MUST follow these rules to ensure security, performance, and maintainability.

- **Authentication**: Only `AuthServicesImpl` may call `FirebaseAuth`. All auth flows (email/password, Google, Facebook) MUST return a `bool` — exceptions must be caught and surfaced as cubit error states, never let propagate to widgets.
- **Firestore**: All reads and writes use `FirestoreServices.instance` generic methods (`setData`, `getDocument`, `collectionStream`, etc.). No feature code imports `cloud_firestore` directly outside of `FirestoreServices`.
- **FCM**: Notification handling (background handler, foreground listener, `onMessageOpenedApp`) is initialised once in `main.dart` before `runApp`. Navigation from notifications MUST use the global `navigatorKey` and route through `AppRouter`.
- **Security rules**: Firestore security rules MUST enforce per-user data isolation for `users/{userId}/**` collections. Public collections (`products/`, `categories/`, `announcements/`) are read-only for authenticated users.
- Sensitive Firebase configuration files (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) MUST NOT be committed to public repositories.

**Rationale**: Centralising Firebase access prevents scattered credential handling, makes it testable through one seam, and keeps security rules aligned with the data model.

## Technology Standards

**Platform**: Flutter (Dart SDK ≥ 3.0.2), targeting Android & iOS.

**State management**: `flutter_bloc ^8.x` — Cubit pattern only (BLoC stream API not used in this project).

**Backend**: Firebase (core, auth, firestore, messaging). No other backend is introduced without a constitution amendment.

**Authentication providers**: Email/password, Google Sign-In, Facebook Login — all via `firebase_auth` credential model.

**Navigation**: Flutter named routes (`MaterialApp.onGenerateRoute`). No `go_router` or other routing library unless adopted via amendment.

**Dependency rules**:
- A new `pub.dev` package MUST be justified in the PR description with: use-case, pub score ≥ 80, last publish ≤ 18 months ago.
- Direct dependencies are pinned with `^major.minor.0` constraints.
- `flutter_lints` analysis rules MUST pass with zero warnings before merge (`flutter analyze` must exit clean).

**Asset conventions**: Images in `assets/images/`. No binary assets > 500 KB committed without explicit approval.

## Development Workflow & Quality Gates

**Feature branch naming**: `###-short-description` (e.g., `061-order-history`).

**Commit format**: `<type>: <description>` — types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`.

**Pull request gates** — ALL MUST pass before merge:
- [ ] `flutter analyze` exits with zero issues
- [ ] `flutter test` passes with ≥ 80% coverage
- [ ] Constitution Check in plan.md passes for all seven principles
- [ ] No hardcoded strings (UI labels in `const` or localization); no hardcoded colors (use `AppColors`)
- [ ] No direct Firestore access outside `FirestoreServices`
- [ ] New models have `fromMap`, `toMap`, `copyWith`
- [ ] New routes registered in `AppRoutes` and `AppRouter`

**Code review**: Every PR requires at least one review. Reviewer MUST verify the Constitution Check section of the associated `plan.md`.

**Hotfix policy**: Hotfixes on `master` are permitted for production crashes only. They MUST be back-ported to any active feature branches within 24 hours.

## Governance

This constitution supersedes all other conventions, style guides, and informal agreements in this repository.

**Amendment procedure**:
1. Author opens a PR proposing the amendment with a rationale section.
2. The amendment must reference which principle(s) are affected and the version bump type (MAJOR/MINOR/PATCH).
3. The PR requires explicit approval from the project maintainer.
4. On merge, `LAST_AMENDED_DATE` and `CONSTITUTION_VERSION` are updated and a `docs: amend constitution to vX.Y.Z` commit is made.

**Versioning policy**:
- **MAJOR**: Backward-incompatible removal or redefinition of a principle (e.g., replacing BLoC with Riverpod).
- **MINOR**: New principle or materially expanded guidance added.
- **PATCH**: Clarifications, wording improvements, typo fixes.

**Compliance review**: The Constitution Check section in every `plan.md` is the runtime enforcement mechanism. Any principle violation flagged there MUST be resolved (or explicitly justified in the Complexity Tracking table) before implementation begins.

**Guidance file**: See `CLAUDE.md` at the repository root for the runtime development reference used by AI assistants.

---

**Version**: 1.0.0 | **Ratified**: 2026-05-10 | **Last Amended**: 2026-05-10
