import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await Firebase.initializeApp();
      _initialized = true;
    }
  }

  static Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(dynamic e) onFailed,
    required void Function(dynamic credential) onAutoRetrieved,
    required void Function(String verificationId) onCodeRetrieved,
  }) async {
    await firebase_auth.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (cred) => onAutoRetrieved(cred),
      verificationFailed: (e) => onFailed(e),
      codeSent: (id, token) => onCodeSent(id, token),
      codeAutoRetrievalTimeout: (id) => onCodeRetrieved(id),
    );
  }

  static Future<dynamic> verifyOtp({
    required String smsCode,
    required String verificationId,
  }) async {
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<String?> getIdToken() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    await user.reload();
    return await user.getIdToken();
  }

  static Future<void> signOut() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  static dynamic get currentUser => firebase_auth.FirebaseAuth.instance.currentUser;

  static Future<dynamic> signInWithCredential(firebase_auth.PhoneAuthCredential credential) async {
    return await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
  }
}
