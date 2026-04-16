# Internet Connection Checking

## Package

`internet_connection_checker_plus` (v2.9.1+2) is already declared in `pubspec.yaml`.

It provides two APIs:

- **Stream** — `onStatusChange` — continuous status updates
- **One-shot** — `hasInternetAccess` — async `bool` for point-in-time checks

---

## Custom Check URI — Why `ApiEndpoints.endpoint`?

Instead of checking a generic third-party URL, the app checks its own backend:

```dart
InternetConnection.createInstance(
  customCheckOptions: [
    InternetCheckOption(uri: Uri.parse(ApiEndpoints.endpoint/health)),
  ],
);
```

`ApiEndpoints.endpoint` (from `lib/core/api/model/endpoints.dart`) always resolves to the real production/staging base URL via `FlavorConfig`. We deliberately avoid `ApiEndpoints.v1` because in debug mode that resolves to `http://127.0.0.1:5001/...` (the local emulator), which would give a false "no internet" result on a real device.

---

## `InternetConnectionService` Implementation

File: `lib/data/internet_connection_service.dart`

```dart
import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../core/api/model/endpoints.dart';

class InternetConnectionService {
  late final InternetConnection _connection;
  StreamSubscription<InternetStatus>? _subscription;

  InternetConnectionService() {
    _connection = InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse(ApiEndpoints.endpoint)),
      ],
    );
  }

  /// Returns true if the device can reach the backend right now.
  Future<bool> get hasInternetAccess => _connection.hasInternetAccess;

  /// Continuous stream of connectivity status changes.
  Stream<InternetStatus> get onStatusChange => _connection.onStatusChange;

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
```

---

## DI Registration

File: `lib/core/di/service_locator.dart`

Register it as a lazy singleton **before** any Cubit that depends on it:

```dart
getIt.registerLazySingleton<InternetConnectionService>(
  () => InternetConnectionService(),
);
```

---

## Usage in a Cubit

Inject via constructor, subscribe in the constructor body, and cancel in `close()`.

```dart
class SomeCubit extends Cubit<SomeState> {
  final InternetConnectionService _internetService;
  StreamSubscription<InternetStatus>? _connectivitySub;

  SomeCubit(this._internetService) : super(const SomeState.initial()) {
    _connectivitySub = _internetService.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        // Re-fetch data or emit a connected state
      } else {
        emit(const SomeState.offline());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
```

Register the Cubit in `service_locator.dart`:

```dart
getIt.registerLazySingleton<SomeCubit>(
  () => SomeCubit(getIt<InternetConnectionService>()),
);
```

---

## One-shot Guard Before an API Call

Use `hasInternetAccess` to bail out early instead of letting a network call fail:

```dart
final isOnline = await getIt<InternetConnectionService>().hasInternetAccess;
if (!isOnline) {
  emit(const SomeState.offline());
  return;
}
// proceed with fetch
```

---

## Verification

1. `flutter pub get` — confirm no version conflicts.
2. `flutter run -t lib/main_dev.dart --flavor dev` — start the app.
3. Toggle **airplane mode on** — confirm the stream emits `InternetStatus.disconnected` and the UI reflects it.
4. Toggle **airplane mode off** — confirm the stream emits `InternetStatus.connected` and the UI recovers.
5. Call `hasInternetAccess` just before a fetch — confirm `true` on a live network and `false` in airplane mode.
6. `flutter analyze` — no new warnings.

