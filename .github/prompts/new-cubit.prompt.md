---
description: "Scaffold a new Cubit with state file, following the project's sealed state pattern."
argument-hint: "Cubit name (e.g., 'order_history')"
agent: "agent"
---

Create a new Cubit for the feature `$arguments` in `lib/view_models/{name}_cubit/`.

Generate two files following the existing pattern:

**`{name}_cubit.dart`**:

- Import flutter_bloc and the relevant service
- Use `part '{name}_state.dart'`
- Extend `Cubit<{Name}State>`
- Instantiate the service as a field
- Add async methods that emit Loading → Loaded/Error

**`{name}_state.dart`**:

- Use `part of '{name}_cubit.dart'`
- `sealed class {Name}State` with `const` constructor
- `final class` variants: Initial, Loading, Loaded (with data fields), Error (with message)

Reference [cart_cubit.dart](../../lib/view_models/cart_cubit/cart_cubit.dart) for the exact pattern.
