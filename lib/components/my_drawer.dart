import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  final String currentUserEmail;
  final AuthService _authService = AuthService();

  MyDrawer({Key? key, required this.currentUserEmail}) : super(key: key);

  void logout(BuildContext context) async {
    bool confirmLogout = await _showLogoutConfirmation(context);
    if (confirmLogout) {
      _authService.signOut();

      // Redirect to login page after logout
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // ✅ Profile Info Card with Modern Gradient
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    currentUserEmail[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentUserEmail,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Drawer Items with Icons
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: "Home",
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: "Settings",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),

          const Spacer(), // Push Logout to the Bottom

          // ✅ Logout Button
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: "Logout",
            color: Colors.redAccent,
            onTap: () => logout(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ✅ Drawer Item Builder
  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
        Color? color,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: color ?? Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
