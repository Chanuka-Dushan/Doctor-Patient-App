import 'package:doctor_patient_app/constants/colors.dart';
import 'package:doctor_patient_app/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthServices _auth = AuthServices();
  String? userEmail; // Variable to store the user's email

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes to get the user's email
    _auth.user.listen((userModel) {
      setState(() {
        userEmail = userModel?.email; // Update the email on auth state changes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color.fromARGB(255, 218, 17, 17),
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Icon(Icons.logout, weight: 20),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home Page',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (userEmail != null) ...[
              const Text(
                'Hi, You are Signed as :',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ), // Check if userEmail is not null
              Text(
                'Email: $userEmail',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else
              const Text(
                'No user signed in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
