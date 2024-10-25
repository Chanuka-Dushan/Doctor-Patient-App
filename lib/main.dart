import 'package:doctor_patient_app/models/UserModel.dart';
import 'package:doctor_patient_app/screens/wrapper.dart';
import 'package:doctor_patient_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: ""),  // Provide initial UserModel
      value: AuthServices().user, // Stream of user from AuthServices
      child: MaterialApp(
        title: 'Doctor-Patient App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(), // Route to your wrapper for authentication checks
      ),
    );
  }
}

