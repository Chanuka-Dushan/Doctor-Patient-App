import 'package:doctor_patient_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';


class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookSignIn = FacebookAuth.instance;
  AccessToken? _accessToken;

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
    } catch (err) {
      print(err.toString());
    }
  }

  // Sign up with email and password
  Future<UserModel?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // Sign in with Google
Future<UserModel?> signInWithGoogle() async {
  try {
    // Ensure any previous Google sign-ins are signed out
    await _googleSignIn.signOut();

    // Start the Google sign-in process
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User canceled the sign-in process
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;

    return _userWithFirebaseUserUid(user); // This will now include the email
  } catch (err) {
    print(err.toString());
    return null;
  }
}

  // Sign in with Facebook
Future<UserModel?> signInWithFacebook() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      // Sign in to Firebase with the Facebook credential
      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;

      return _userWithFirebaseUserUid(user);
    } else {
      print("Facebook login failed: ${result.message}");
      return null;
    }
  } catch (err) {
    print(err.toString());
    return null;
  }
}



 String? getCurrentUserEmail() {
    User? user = _auth.currentUser;
    return user?.email; // Return the email if user is not null
  }
}





