import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- COMMON COLORS ---
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color errorColor = Color(0xFFE32F0B);
  static const Color successColor = Color(0xFF1DF605);

  // --- LIGHT THEME COLORS ---
  static const Color _lightSecondaryColor = Color(0xFF636E72);
  static const Color _lightTextPrimaryColor = Color(0xFF333333);
  static const Color _lightTextSecondaryColor = Color(0xFF636E72);
  static const Color _lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color _lightCardColor = Color(0xFFF8F8F8);
  static const Color _lightBorderColor = Color(0xFFDDD6FE);

  // --- DARK THEME COLORS ---
  static const Color _darkSecondaryColor = Color(0xFF9E9E9E);
  static const Color _darkTextPrimaryColor = Color(0xFFFAFAFA);
  static const Color _darkTextSecondaryColor = Color(0xFF9E9E9E);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkCardColor = Color(0xFF1E1E1E);
  static const Color _darkBorderColor = Color(0xFF333333);

  // --- LIGHT THEME DEFINITION ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: _lightSecondaryColor,
      surface: _lightBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: errorColor,
      onSurface: _lightTextPrimaryColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: _lightTextPrimaryColor),
      headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: _lightTextPrimaryColor),
      headlineSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: _lightTextPrimaryColor),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: _lightTextPrimaryColor),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal, color: _lightTextSecondaryColor),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: _lightTextSecondaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _lightTextPrimaryColor),
      iconTheme: IconThemeData(color: _lightTextPrimaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: _lightCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _lightBorderColor, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightCardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _lightBorderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _lightBorderColor)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: errorColor)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // --- DARK THEME DEFINITION ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: _darkSecondaryColor,
      surface: _darkBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: errorColor,
      onSurface: _darkTextPrimaryColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: _darkTextPrimaryColor),
      headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: _darkTextPrimaryColor),
      headlineSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: _darkTextPrimaryColor),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: _darkTextPrimaryColor),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal, color: _darkTextSecondaryColor),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: _darkTextSecondaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _darkTextPrimaryColor),
      iconTheme: IconThemeData(color: _darkTextPrimaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: _darkCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _darkBorderColor, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkCardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _darkBorderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _darkBorderColor)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: errorColor)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
