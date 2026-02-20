import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _userSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
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

  Stream<AppUser?> getUser() {
    final stream = _authRepository.getUser();
    _userSubscription = stream.listen((AppUser? user) {
      emit(
        user != null
            ? AuthState.authenticated(user: user)
            : AuthState.unauthenticated(),
      );
    });
    return stream;
  }
}
