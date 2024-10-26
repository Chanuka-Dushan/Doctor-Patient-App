import 'package:doctor_patient_app/constants/styles.dart';
import 'package:doctor_patient_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  final Function toggle;

  const Register({super.key, required this.toggle});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool isLoading = false; 
  String? errorMessage; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        errorMessage = null; // Reset error message
      });

      try {
        setState(() {
          isLoading = true; // Set loading to true
        });

        // Process registration
        await _auth.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        // Handle successful registration (e.g., navigate to home page)
        // You can add navigation logic here

      } on FirebaseAuthException catch (e) {
        // Handle Firebase authentication errors specifically
        setState(() {
          switch (e.code) {
            case 'weak-password':
              errorMessage = 'The password provided is too weak.';
              break;
            case 'email-already-in-use':
              errorMessage = 'The account already exists for that email.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is not valid.';
              break;
            default:
              errorMessage = 'An unknown error occurred. Please try again.';
              break;
          }
        });
      } catch (e) {
        // Handle other types of errors
        setState(() {
          errorMessage = 'An unexpected error occurred: ${e.toString()}';
        });
      } finally {
        setState(() {
          isLoading = false; // Set loading to false
        });
      }
    }
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
                    'Create Account',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/logo1.png'),
                      height: 150,
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
                  if (errorMessage != null) // Show error message if exists
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: labelStyle),
                      TextButton(
                        onPressed: () {
                          widget.toggle(); // Navigate to login page
                        },
                        child: const Text('Login', style: linkTextStyle),
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
                          // Sign in with Facebook
                        },
                        child: const Icon(Icons.facebook_rounded, size: 40, color: Colors.blue),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true; // Set loading to true
                            });
                            await _auth.signInWithGoogle();
                            // Handle successful sign-in (e.g., navigate to home page)
                          } catch (e) {
                            setState(() {
                              errorMessage = e.toString(); // Set error message
                            });
                          } finally {
                            setState(() {
                              isLoading = false; // Set loading to false
                            });
                          }
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
                    onPressed: isLoading ? null : _registerUser,
                    style: elevatedButtonStyle,
                    child: isLoading
                      ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                      : const Text('Register'),
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
