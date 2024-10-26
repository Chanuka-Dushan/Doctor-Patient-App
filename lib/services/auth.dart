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

  // Create a stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookSignIn.logOut();
      await _auth.signOut();
      await _secureStorage.delete(key: 'session_token'); // Clear session
    } catch (err) {
      print("Sign out error: ${err.toString()}");
    }
  }

  // Sign up with email and password
  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _secureStorage.write(key: 'session_token', value: result.user?.uid); // Store session
      return "Registration successful"; // or return user model if needed
    } catch (err) {
      return "Registration error: ${err.toString()}"; // Return error message
    }
  }

  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _secureStorage.write(key: 'session_token', value: result.user?.uid); // Store session
      return "Login successful"; // or return user model if needed
    } catch (err) {
      return "Login error: ${err.toString()}"; // Return error message
    }
  }

  // Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
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
      return "Google login error: ${err.toString()}"; // Return error message
    }
  }

  // Sign in with Facebook
  Future<String?> signInWithFacebook() async {
    try {
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
        return "Facebook login failed: ${result.message}"; // Return error message
      }
    } catch (err) {
      return "Facebook login error: ${err.toString()}"; // Return error message
    }
  }

  String? getCurrentUserEmail() {
    User? user = _auth.currentUser;
    return user?.email; // Return the email if user is not null
  }
}
