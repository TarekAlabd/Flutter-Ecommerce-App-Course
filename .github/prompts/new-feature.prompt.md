---
description: "Scaffold a new feature following the MVVM + Cubit pattern: model, service, cubit, state, page, and route registration."
argument-hint: "Feature name (e.g., 'orders', 'wishlist')"
agent: "agent"
---

Create a new feature for this Flutter e-commerce app. Follow the existing architecture in [AGENTS.md](../../AGENTS.md).

Generate these files for the feature `$arguments`:

1. **Model** in `lib/models/` — immutable with `fromMap`, `toMap`, `copyWith`
2. **Service** in `lib/services/` — abstract class + `*Impl` using `FirestoreServices.instance` and `ApiPaths`
3. **Cubit + State** in `lib/view_models/{feature}_cubit/` — use `part`/`part of`, sealed state classes
4. **Page** in `lib/views/pages/` — uses `BlocBuilder` to render states
5. **Route** — add constant in `lib/utils/app_routes.dart` and case in `lib/utils/app_router.dart`
6. **Firestore path** — add static method in `lib/utils/api_paths.dart`

Follow the patterns in existing files like `cart_cubit.dart`, `cart_services.dart`, and `add_to_cart_model.dart`.
