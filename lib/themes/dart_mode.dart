import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
      colorScheme: ColorScheme.dark(
            background: const Color(0xFF121212), // Deep black for a premium look
            primary: const Color(0xFFBB86FC), // Soft purple highlight (consistent with Material Design)
            secondary: const Color(0xFF1F1F1F), // Dark grey for card surfaces
            tertiary: const Color(0xFF2C2C2C), // Mid-tone grey for buttons
            inversePrimary: const Color(0xFFE1E1E1), // Light grey for text/icons
      ),

      scaffoldBackgroundColor: const Color(0xFF121212), // Consistent dark background
      appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
            ),
      ),

      textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.grey),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),

      iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24,
      ),

      cardColor: const Color(0xFF1F1F1F), // Dark grey for card surfaces

      buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFFBB86FC), // Soft purple for buttons
            textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBB86FC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                  ),
            ),
      ),

      inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFFBB86FC)),
            ),
            enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
            ),
      ),
);
