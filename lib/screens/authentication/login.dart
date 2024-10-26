import 'package:doctor_patient_app/constants/styles.dart';
import 'package:doctor_patient_app/services/auth.dart';
import 'package:flutter/material.dart';

class Sign_In extends StatefulWidget {
  final Function toggle;
  const Sign_In({super.key, required this.toggle});

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
   final AuthServices _auth=AuthServices();
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Login',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/logo1.png'),
                      height: 250,
                    ),
                  ),
                  const SizedBox(height: 30),
                 
                  
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: inputTextStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                    style: inputTextStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: labelStyle),
                      TextButton(
                        onPressed: () {
                          // Navigate to login page
                        },
                        child:  GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: const Text('Register', style: linkTextStyle)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      "or",
                      style: dividerTextStyle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Sign in with",
                      style: labelStyle,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Sign in with facebook
                        },
                        child: const Icon(Icons.facebook_rounded, size: 40, color: Colors.blue)),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // Sign in with google
                          dynamic result= _auth.signInWithGoogle();
                          
                        },
                        child: const Image(
                          image: AssetImage("assets/search.png"),
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Login user
                        dynamic result=await _auth.signInWithEmailandPassword(_emailController.text,_passwordController.text);
                     
                      }
                    },
                    style: elevatedButtonStyle,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
