import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        background: const Color(0xFFF5F5F5), // Light grey for a soft background
        primary: const Color(0xFF6200EE), // Deep purple for highlights (Material Design)
        secondary: const Color(0xFFE0E0E0), // Light grey for surfaces
        tertiary: Colors.white, // Pure white for cards and buttons
        inversePrimary: const Color(0xFF212121), // Dark grey for text/icons
    ),

    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey background
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
        ),
    ),

    textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.grey),
        titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),

    iconTheme: const IconThemeData(
        color: Colors.black,
        size: 24,
    ),

    cardColor: Colors.white, // Clean white surface for cards

    buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF6200EE), // Deep purple for buttons
        textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6200EE),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
            ),
        ),
    ),

    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6200EE)),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
        ),
    ),
);
