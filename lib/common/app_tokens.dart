import 'package:flutter/material.dart';

class AppTokens {
  AppTokens._();

  static const Color pantryDark = Color(0xFF161311);
  static const Color surfaceWarm = Color(0xFF221D19);
  static const Color surfaceElevated = Color(0xFF2E2722);
  static const Color borderWarm = Color(0xFF3D342D);

  static const Color terracotta = Color(0xFFDE6B48);
  static const Color honeyAmber = Color(0xFFF4A245);
  static const Color sageGreen = Color(0xFF5BA876);
  static const Color crimsonAlert = Color(0xFFE24E42);

  static const Color textLight = Color(0xFFFBF9F5);
  static const Color textMuted = Color(0xFFA69C92);
  static const Color textDim = Color(0xFF6E655C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pantryDark,
      primaryColor: terracotta,
      colorScheme: const ColorScheme.dark(
        primary: terracotta,
        secondary: honeyAmber,
        surface: surfaceWarm,
        error: crimsonAlert,
        onPrimary: Colors.white,
        onSecondary: pantryDark,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWarm,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: honeyAmber),
      ),
      cardTheme: CardThemeData(
        color: surfaceWarm,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: borderWarm, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceWarm,
        indicatorColor: terracotta.withAlpha(45),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: honeyAmber,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: honeyAmber);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderWarm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderWarm),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: honeyAmber, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textDim, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
