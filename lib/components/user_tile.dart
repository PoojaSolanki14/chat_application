import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String email;
  final String? username;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.email,
    this.username,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), // Light gray
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // User icon
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary, // Matches primary theme color
            ),
            const SizedBox(width: 20),
            // Display Username (fallback to email if username is not available)
            Expanded(
              child: Text(
                username ?? email,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground, // Matches text theme
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
