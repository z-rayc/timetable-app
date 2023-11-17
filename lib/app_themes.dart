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
  orange(Color.fromRGBO(255, 166, 61, 1));

  const CalendarItemColour(this.colour);
  final Color colour;
}

const double kDefaultBorderRadius = 20.0;
const Color kThemeSeedColour = Color.fromRGBO(140, 20, 197, 1);
const Color kOffWhite = Color.fromRGBO(240, 240, 240, 1);
const double kDrawerBorderRadius = 30.0;
const double kBottomNavBarRounding = 25;

const BoxDecoration splashBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(colors: [
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.blue,
  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
);

/// This class contains the universal themes for the app used in multiple components.
class AppThemes {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kThemeSeedColour,
      ).copyWith(
        background: kOffWhite,
        secondary: const Color.fromRGBO(239, 239, 239, 1),
        onSecondary: const Color.fromRGBO(0, 0, 0, 1),
        tertiary: const Color.fromARGB(255, 174, 174, 174),
        onTertiary: const Color.fromRGBO(0, 0, 0, 1),
      ),
      textTheme: GoogleFonts.alataTextTheme(),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        titleAlignment: ListTileTitleAlignment.center,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kThemeSeedColour,
        titleTextStyle: AppBarThemes.titleTextStyle,
        foregroundColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(kDrawerBorderRadius),
            bottomRight: Radius.circular(kDrawerBorderRadius),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kThemeSeedColour,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static Color get accentColour {
    return const Color.fromRGBO(206, 148, 251, 1);
  }

  static ButtonStyle get entryButtonTheme {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: AppThemes.theme.textTheme.bodyMedium!.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        kThemeSeedColour,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 255, 255, 1),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
      ),
    );
  }

  static ButtonStyle get entrySecondaryButtonTheme {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 255, 255, 1),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(0, 0, 0, 1),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
      ),
    );
  }

  static InputDecoration get entryFieldTheme {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: BorderSide.none,
      ),
      fillColor: const Color.fromRGBO(255, 255, 255, 1),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  static BoxShadow boxShadow(double radius) {
    return BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: radius,
      offset: const Offset(2, 2),
    );
  }

  static BoxDecoration get listViewContainerDecoration {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(2, 2),
        )
      ],
    );
  }

  static BoxDecoration get textFormFieldBoxDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(2, 2),
        )
      ],
    );
  }

  static BoxDecoration get bottomNavBarBoxDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(kBottomNavBarRounding),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(2, 2),
        ),
      ],
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
