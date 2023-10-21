import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppThemes {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(140, 20, 197, 1),
      ).copyWith(
        background: const Color.fromRGBO(240, 240, 240, 1),
        secondary: const Color.fromRGBO(239, 239, 239, 1),
      ),
      textTheme: GoogleFonts.alataTextTheme(),
    );
  }

  static Color get accentColour {
    return const Color.fromRGBO(206, 148, 251, 1);
  }
