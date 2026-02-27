import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:coffix_app/features/auth/data/model/user_with_store.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final StoreRepository _storeRepository;
  StreamSubscription<AppUser?>? _userSubscription;
  StreamSubscription<AppUserWithStore?>? _userWithStoreSubscription;

  AuthCubit({
    required AuthRepository authRepository,
    required StoreRepository storeRepository,
  }) : _authRepository = authRepository,
       _storeRepository = storeRepository,
       super(AuthState.initial());

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // emit(AuthState.authenticated());
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthState.loading());
    try {
      await _authRepository.signOut();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> createAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthState.loading());
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithGoogle();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(AuthState.initial());
        return;
      }
      emit(AuthState.error(message: e.code.name));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signInWithApple() async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithApple();
    } on SignInWithAppleException catch (e) {
      emit(AuthState.error(message: e.toString()));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  void updateLastLogin() async {
    await _authRepository.updateLastLogin();
  }

  void getUserWithStore() {
    updateLastLogin();
    final stream = _storeRepository.getUserWithStore();
    _userWithStoreSubscription?.cancel();
    _userWithStoreSubscription = stream.listen(
      (AppUserWithStore? user) {
        emit(
          user != null
              ? AuthState.authenticated(userWithStore: user)
              : AuthState.unauthenticated(),
        );
      },
      onError: (error) {
        emit(AuthState.error(message: error.toString()));
      },
    );
  }
}
