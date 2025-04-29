import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';
import 'dart:ui';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ✅ Register Function
  void register(BuildContext context) async {
    if (_pwController.text != _confirmPwController.text) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _pwController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );

      _emailController.clear();
      _pwController.clear();
      _confirmPwController.clear();
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Google Sign-In Function
  void signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showErrorDialog("Google Sign-In failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D2671),
      body: Stack(
        children: [
          // ✅ Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D2671), Color(0xFFC33764)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ✅ Glassmorphism Card
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_add, size: 80, color: Colors.white),
                          const SizedBox(height: 15),

                          // Title
                          const Text(
                            "Create an Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Sign up to get started",
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),

                          const SizedBox(height: 20),

                          // ✅ Input Fields
                          MyTextfield(
                            hintText: "Email",
                            obscureText: false,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 12),

                          MyTextfield(
                            hintText: "Password",
                            obscureText: true,
                            controller: _pwController,
                          ),
                          const SizedBox(height: 12),

                          MyTextfield(
                            hintText: "Confirm Password",
                            obscureText: true,
                            controller: _confirmPwController,
                          ),
                          const SizedBox(height: 20),

                          // ✅ Register Button
                          _isLoading
                              ? const CircularProgressIndicator()
                              : MyButton(
                            text: "Register",
                            onTap: () => register(context),
                          ),

                          const SizedBox(height: 15),

                          // ✅ Google Sign-In Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // ✅ Increased padding
                              minimumSize: const Size(double.infinity, 50), // ✅ Full-width button and increased height
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // ✅ Slightly larger corner radius
                              ),
                            ),
                            icon: Image.asset(
                              'assets/google.png',
                              height: 30, // ✅ Larger logo size
                              width: 30,
                            ),
                            label: const Text(
                              "Continue with Google",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // ✅ Bigger font size
                            ),
                            onPressed: signInWithGoogle,
                          ),

                          const SizedBox(height: 15),

                          // ✅ Already have an account
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Already have an account? Log in",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
