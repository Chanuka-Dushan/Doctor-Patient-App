import 'package:doctor_patient_app/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //create a obj from firebase _auth=AuthServices();
  final AuthServices _auth=AuthServices();
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Home"),

      actions: [
        ElevatedButton(onPressed: ()async{
          await _auth.signOut();
        }, child: const Icon(Icons.logout))
      ],
      ),
    ),
      
    );
  }
}