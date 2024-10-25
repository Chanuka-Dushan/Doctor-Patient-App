import 'package:doctor_patient_app/screens/authentication/login.dart';
import 'package:doctor_patient_app/screens/authentication/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signinPage=true;

  void switchPage(){
    setState(() {
      signinPage=!signinPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(signinPage==true){
      return  Sign_In(toggle: switchPage,);
    }
    else{
      return Register(toggle: switchPage,);
    }

  }
}