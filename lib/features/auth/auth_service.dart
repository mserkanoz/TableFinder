import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Wraps Google Sign-In + Firebase Auth behind a small API.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn.instance;
  bool _googleReady = false;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _ensureGoogleReady() async {
    if (_googleReady) return;
    // The web client ID is read from google-services.json automatically.
    await _google.initialize();
    _googleReady = true;
  }

  /// Returns null if the user cancelled the Google account picker.
  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleReady();
    try {
      final account = await _google.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _ensureGoogleReady();
    await _google.signOut();
    await _auth.signOut();
  }
}
