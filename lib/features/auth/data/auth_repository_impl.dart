import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/core/api/endpoints.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserDoc(
        docId: credential.user!.uid,
        email: credential.user!.email!,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      await _auth.signInWithProvider(AppleAuthProvider());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ["email"],
      );

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      if (authorization == null) {
        throw Exception("Google Sign In failed: No authorization found");
      }

      final GoogleSignInAuthentication authentication = account.authentication;

      if (authentication.idToken == null) {
        throw Exception("Google Sign In failed: No ID token found");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: authentication.idToken,
      );

      try {
        final credentialResult = await _auth.signInWithCredential(credential);
        await createUserDoc(
          docId: credentialResult.user!.uid,
          email: credentialResult.user!.email!,
        );
        return credentialResult;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw Exception(
            'An account already exists with this email. '
            'Please sign in with your email and password first, then link your Google account from settings.',
          );
        }
        rethrow;
      }
    } on GoogleSignInException catch (e) {
      print(
        'Google Sign In error: code: ${e.code.name} description:${e.description} details:${e.details}',
      );
      rethrow;
    } catch (error) {
      print('Unexpected Google Sign-In error: $error');
      rethrow;
    }
  }

  @override
  Future<void> createUserDoc({
    required String docId,
    required String email,
  }) async {
    try {
      await _firestore.collection('customers').doc(docId).set({
        'docId': docId,
        'email': email,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<AppUser?> getUser() {
    return _firestore
        .collection('customers')
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .map((event) {
          return AppUser.fromJson(event.data() ?? {});
        });
  }

  @override
  Future<void> sendEmailVerification({required String email}) async {
    final token = await _auth.currentUser?.getIdToken();
    log(token ?? '');
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse(
        '${ApiEndpoints.baseUrl}/coffix-app-dev/us-central1/v1/otp/send',
      ),
      headers: {'Authorization': 'Bearer $token'},
      body: {'email': email},
    );
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to send email verification');
    }
  }

  @override
  Future<void> verifyOtp({required String otp}) async {
    final token = await _auth.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse(
        '${ApiEndpoints.baseUrl}/coffix-app-dev/us-central1/v1/otp/verify',
      ),
      headers: {'Authorization': 'Bearer $token'},
      body: {'otp': otp},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP');
    }
  }

  @override
  Future<void> updateLastLogin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('No user found');
    }
    await _firestore.collection("customers").doc(_auth.currentUser?.uid).update(
      {"lastLogin": DateTime.now()},
    );
  }
}
