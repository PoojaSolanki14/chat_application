import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextfield({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12), // ✅ Rounded Corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12), // ✅ Rounded Corners
          ),
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), // ✅ Enhanced Contrast
            fontSize: 14,
          ),
          // ✅ Clear Button
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => controller.clear(),
          )
              : null,
        ),
      ),
    );
  }
}
