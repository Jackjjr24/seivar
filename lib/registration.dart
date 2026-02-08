import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'survey_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Create user in Firebase
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to Survey Page on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SurveyPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";
      if (e.code == 'email-already-in-use') {
        message = "Email already exists";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 30),

                // Fields
                _buildTextField(Icons.person, "Full Name", controller: _nameController),
                SizedBox(height: 15),
                _buildTextField(Icons.email, "Email Address", controller: _emailController),
                SizedBox(height: 15),
                _buildTextField(Icons.person_outline, "Username", controller: _usernameController),
                SizedBox(height: 15),
                _buildTextField(Icons.lock, "Password", controller: _passwordController, isPassword: true),
                SizedBox(height: 15),
                _buildTextField(Icons.lock_outline, "Confirm Password", controller: _confirmPasswordController, isPassword: true),

                SizedBox(height: 25),

                // Register button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("Register", style: TextStyle(fontSize: 16)),
                ),

                SizedBox(height: 20),

                // Already have account
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to login
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: Colors.indigo),
                      SizedBox(width: 5),
                      Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable text field
Widget _buildTextField(IconData icon, String hintText,
    {bool isPassword = false, TextEditingController? controller}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.indigo),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}
