import 'package:doctor_patient_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookSignIn = FacebookAuth.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Create a user from uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // Stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  Future<void> signOut({Function(bool)? onLoading, Function(String?)? onError}) async {
    try {
      if (onLoading != null) onLoading(true);
      await _googleSignIn.signOut();
      await _facebookSignIn.logOut();
      await _auth.signOut();
      await _secureStorage.delete(key: 'session_token'); // Clear session
    } catch (err) {
      if (onError != null) onError("Sign out error: ${err.toString()}");
    } finally {
      if (onLoading != null) onLoading(false);
    }
  }

  // Sign up with email and password
 // Register with email and password
  Future<dynamic> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Your Firebase registration logic here
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw e; // Throw the error to be caught in the UI
    }
  }

  // Sign in with email and password
  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw e; // Throw the error to be caught in the UI
    }
  }

  // Sign in with Google
  Future<String?> signInWithGoogle({Function(bool)? onLoading, Function(String?)? onError}) async {
    try {
      if (onLoading != null) onLoading(true);
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return "Google sign-in canceled"; // User canceled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      await _secureStorage.write(key: 'session_token', value: result.user?.uid); // Store session
      return "Google login successful";
    } catch (err) {
      if (onError != null) onError("Google login error: ${err.toString()}");
      return null;
    } finally {
      if (onLoading != null) onLoading(false);
    }
  }

  // Sign in with Facebook
  Future<String?> signInWithFacebook({Function(bool)? onLoading, Function(String?)? onError}) async {
    try {
      if (onLoading != null) onLoading(true);
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        await _secureStorage.write(key: 'session_token', value: userCredential.user?.uid); // Store session
        return "Facebook login successful";
      } else {
        if (onError != null) onError("Facebook login failed: ${result.message}");
        return null;
      }
    } catch (err) {
      if (onError != null) onError("Facebook login error: ${err.toString()}");
      return null;
    } finally {
      if (onLoading != null) onLoading(false);
    }
  }

  String? getCurrentUserEmail() {
    User? user = _auth.currentUser;
    return user?.email; // Return the email if user is not null
  }
}
