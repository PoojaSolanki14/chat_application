import 'package:chat_application/services/auth/auth_service.dart';
import 'package:chat_application/components/my_button.dart';
import 'package:chat_application/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in Animation
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
    _animationController.dispose();
    super.dispose();
  }

  // Login Function
  void login(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _pwController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Google Sign-In Function
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

  // Error Dialog
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
            child: ClipRRect(
            borderRadius: BorderRadius.circular(24), // Ensures blur effect is clipped
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
    // ✅ Logo
    const Icon(Icons.chat_bubble, size: 80, color: Colors.white),

    const SizedBox(height: 15),
    const Text(
    "Welcome Back!",
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 5),
    const Text(
    "Sign in to continue",
    style: TextStyle(
    fontSize: 16,
    color: Colors.white70,
    ),
    ),
    const SizedBox(height: 20),

    // ✅ Email Field
    MyTextfield(
    hintText: "Email",
    obscureText: false,
    controller: _emailController,
    ),
    const SizedBox(height: 12),

    // ✅ Password Field
    MyTextfield(
    hintText: "Password",
    obscureText: true,
    controller: _pwController,
    ),
    const SizedBox(height: 16),

    // ✅ Login Button
    _isLoading
    ? const CircularProgressIndicator(color: Colors.white)
        : MyButton(
    text: "Login",
    onTap: () => login(context),
    ),

    const SizedBox(height: 10),

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

    // ✅ Register Now Link
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text("Not a member?", style: TextStyle(color: Colors.white70)),
    GestureDetector(
    onTap: widget.onTap,
    child: const Text(
    " Register now",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    ),
    ),
    )

    ],
      ),
    );
  }
}
