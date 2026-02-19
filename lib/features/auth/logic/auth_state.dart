part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  // Initial state when app starts (checking auth status).
  const factory AuthState.initial() = _Initial;

  // Loading state (e.g., checking tokens, fetching user profile).
  const factory AuthState.loading() = _Loading;

  // User is authenticated and has completed onboarding
  const factory AuthState.authenticated() = _Authenticated;

  // User is not authenticated (logged out or no valid tokens).
  const factory AuthState.unauthenticated() = _Unauthenticated;

  // Authentication failed with an error message.
  const factory AuthState.error({required String message}) = _Error;
}
