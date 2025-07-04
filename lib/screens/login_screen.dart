import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'forgetpswd_screen.dart';
import 'package:neurogambling_scanner/appfeatures/home_screen.dart';
import 'package:neurogambling_scanner/widgets/custom_button.dart'; // Import reusable button

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to Home Screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);

      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password. Please try again.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(height: 80),
                Image.network(
                      "icons/logoo.png", width: 100, height: 100), // Use Asset instead of Network
              //   Image.asset(
              //   'assets/icon/app_icon.png',
              //   width: 100,
              //   height: 100,
              //   errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50),
              // ),

              const SizedBox(height: 20),//150 without image
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Log in to your account and continue your journey",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              _buildTextInput(
                controller: _emailController,
                hint: "Email Address",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildTextInput(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock,
                obscureText: true,

                validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  ),
                  child: const Text("Forgot your password?", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              // Use CustomButton for Login
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "Log in",
                      onPressed: _login,
                    ),

              const SizedBox(height: 20),
              const Text("Don't have an account yet?", style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 10),

              // Use CustomButton for Signup
              CustomButton(
                text: "Create an account",
                 color: Colors.white, // White background
                 textColor: Colors.blueAccent, // Blue text
                 borderColor: Colors.blueAccent, // Blue border
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
