import 'package:flutter/material.dart';

class KelpicoTheme {
  static const bg = Color(0xFFFAFAF9);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFE7E5E4);
  static const accent = Color(0xFFF97316);
  static const accentLight = Color(0xFFFDBA74);
  static const ink = Color(0xFF291503);
  static const green = Color(0xFF16A34A);
  static const red = Color(0xFFDC2626);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: ink,
        iconTheme: IconThemeData(color: ink),
      ),
    );
  }
}
