# 🌊 Riverpod State Management Pattern

In this project, we treat the `build()` method of our Notifiers as the single source of truth for fetching initial data. This ensures that refreshing the UI is as simple as disposing of the current state.

## 📌 Core Philosophy

The `build()` method must fetch the initial data required for the state. If the data depends on another provider (like an authenticated user), we `ref.watch` that provider.

By structuring our Notifiers this way, refreshing data from the backend is handled entirely by Riverpod. We simply call `ref.invalidate(theProvider)`, which destroys the current state and forces `build()` to re-run.

## 💻 Pattern Examples

### Example 1: Dependent Data Fetching

When fetching data that requires an ID from another provider (like a User UID), return `null` if the dependency is missing, and fetch the data if it exists.

```dart
@override
Future<PersonalInfo?> build() async {
  // 1. Watch the auth stream. If auth changes, build() re-runs automatically.
  final authUser = ref.watch(firebaseAuthStreamProvider).value;

  // 2. Handle the unauthenticated state.
  if (authUser == null) return null;

  // 3. Fetch and return the data from the repository.
  final repository = ref.watch(myPersonalInfoRepoProvider);
  return await repository.getByID(authUser.uid);
}
```
