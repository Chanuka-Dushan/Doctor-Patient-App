import 'package:doctor_patient_app/constants/styles.dart';
import 'package:doctor_patient_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sign_In extends StatefulWidget {
  final Function toggle;
  const Sign_In({super.key, required this.toggle});

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage; // Variable to hold the error message
  bool isLoading = false; // Variable to hold loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 Future<void> _loginUser() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      errorMessage = null; // Reset error message
    });

    try {
      setState(() {
        isLoading = true; // Set loading to true
      });

      // Process login
      await _auth.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      // Handle successful login (e.g., navigate to home page)

    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email. Please register first.';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled.';
            break;
          default:
            errorMessage = 'Invalid Credentials .error occurred.';
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
                      const Text("Don't have an account?", style: labelStyle),
                      TextButton(
                        onPressed: () {
                          widget.toggle(); // Navigate to register page
                        },
                        child: const Text('Register', style: linkTextStyle),
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
                        onTap: () async {
                          setState(() {
                            isLoading = true; // Set loading state
                          });
                          try {
                            await _auth.signInWithFacebook();
                            // Handle successful login (e.g., navigate to home page)
                          } catch (e) {
                            setState(() {
                              errorMessage = 'Facebook login failed: ${e.toString()}'; // Set error message
                            });
                          } finally {
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                          }
                        },
                        child: const Icon(Icons.facebook_rounded, size: 40, color: Colors.blue),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true; // Set loading state
                          });
                          try {
                            await _auth.signInWithGoogle();
                            // Handle successful login (e.g., navigate to home page)
                          } catch (e) {
                            setState(() {
                              errorMessage = 'Google login failed: ${e.toString()}'; // Set error message
                            });
                          } finally {
                            setState(() {
                              isLoading = false; // Reset loading state
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
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _loginUser,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
