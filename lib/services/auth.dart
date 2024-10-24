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


}