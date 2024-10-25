import 'package:doctor_patient_app/constants/colors.dart';
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
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,

      actions: [
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(bgColor),
          ),
          onPressed: ()async{
          await _auth.signOut();
        }, child: const Icon(Icons.logout,),)
      ],
      ),
      body: Center(
        child: const Column(
          children: [
            Text('Home Page',style: TextStyle(color: Colors.amber,fontSize: 40,fontWeight: FontWeight.w900),
            ),
          ],
        
        ),
      ),
    ),
      
    );
  }
}