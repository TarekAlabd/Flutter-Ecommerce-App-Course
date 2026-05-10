---
description: "Use when creating or modifying BLoC Cubits, state classes, or state management logic in this Flutter app."
applyTo: "lib/view_models/**/*.dart"
---

# Cubit & State Patterns

## File Structure

Each feature cubit uses `part`/`part of`:

```dart
// feature_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
part 'feature_state.dart';

class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit() : super(FeatureInitial());
  final featureServices = FeatureServicesImpl();
  // ...
}
```

```dart
// feature_state.dart
part of 'feature_cubit.dart';

sealed class FeatureState {
  const FeatureState();
}
final class FeatureInitial extends FeatureState {}
final class FeatureLoading extends FeatureState {}
final class FeatureLoaded extends FeatureState {
  final List<Item> items;
  const FeatureLoaded(this.items);
}
final class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
}
```

## Key Rules

- States are `sealed class` with `final class` variants
- State constructors must be `const`
- Always emit `Loading` before async work, then `Loaded` or `Error`
- Wrap async calls in `try/catch`, emit `Error` with `e.toString()`
- Services are instantiated as fields, not injected
