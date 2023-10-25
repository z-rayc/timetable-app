import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/**
 * Examples of how to use these themes you can see in splash_screen.dart right now.
 */

/// This enum contains the gradients you can use for the calendar items.
enum CalendarItemColour {
  green(Color.fromRGBO(140, 255, 130, 1)),
  lightBlue(Color.fromRGBO(130, 233, 255, 1)),
  lightRed(Color.fromRGBO(255, 130, 160, 1)),
  yellow(Color.fromRGBO(251, 255, 74, 1)),
  purple(Color.fromRGBO(215, 130, 255, 1)),
  turquoise(Color.fromRGBO(61, 255, 185, 1)),
  orange(Color.fromRGBO(255, 166, 61, 1)),
  ;

  const CalendarItemColour(this.colour);
  final Color colour;
}

/// This class contains the universal themes for the app used in multiple components.
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

  static ButtonStyle get entryButtonTheme {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        accentColour,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 255, 255, 1),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

/// Specific themes for the app bar.
class AppBarThemes {
  static TextStyle get titleTextStyle {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
  }
}

/// Specific themes for the calendar.
/// To use the gradient, choose a colour from the enum [CalendarItemColour].
class CalendarItemTheme {
  static BoxDecoration calendarDecoration(CalendarItemColour startColour) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          startColour.colour,
          const Color.fromRGBO(255, 255, 255, 0.9),
        ],
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}