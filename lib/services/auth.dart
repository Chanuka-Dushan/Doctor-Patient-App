import 'package:doctor_patient_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


//create a user from uid
UserModel? _userwithFirebaseUserUid(User? user){
  return user !=null? UserModel(uid: user.uid): null;
}

//create a stream for cheking  the auth changes in the user
Stream<UserModel?>get user{
  return _auth.authStateChanges().map(_userwithFirebaseUserUid);
}

Future signOut()async{
  try{
    return await _auth.signOut();
  }catch(err){
    print(err.toString());
    return null;
  }
}

//sign in with email and password
Future registerWithEmailandPassword(String email,String password)async{
  try{
    UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user=result.user;

    return _userwithFirebaseUserUid(user);
  }catch(err){
    print(err.toString());
    return null;
  }
}

Future signInWithEmailandPassword(String email,String password)async{
  try{
    UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user=result.user;

    return _userwithFirebaseUserUid(user);
  }catch(err){
    print(err.toString());
    return null;
  }
}

// Sign in with Google
  Future signInWithGoogle() async {
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
    return _userwithFirebaseUserUid(user);
  } catch (err) {
    print(err.toString());
    return null;
  }
}


}