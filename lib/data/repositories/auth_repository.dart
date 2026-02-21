import 'package:coffix_app/features/auth/data/model/user.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInWithApple();
  Future<void> createUserDoc({required String docId, required String email});
  Stream<AppUser?> getUser();
  Future<void> sendEmailVerification({required String email});
  Future<void> verifyOtp({required String otp});
  Future<void> updateLastLogin();
}
