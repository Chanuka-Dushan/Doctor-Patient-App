import 'package:doctor_patient_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;

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



}