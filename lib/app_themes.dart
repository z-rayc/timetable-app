import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Examples of how to use these themes you can see in splash_screen.dart right now.

const double kDefaultBorderRadius = 20.0;
const Color kThemeSeedColor = Color.fromRGBO(140, 20, 197, 1);
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
        seedColor: kThemeSeedColor,
      ).copyWith(
        background: kOffWhite,
        secondary: const Color.fromRGBO(156, 39, 176, 1),
        onSecondary: const Color.fromARGB(255, 255, 255, 255),
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
        backgroundColor: kThemeSeedColor,
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
        backgroundColor: kThemeSeedColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 207, 207, 207),
      ),
    );
  }

  static Color get accentColor {
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
        kThemeSeedColor,
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
class CalendarItemTheme {
  static BoxDecoration calendarDecoration(Color startColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          startColor,
          const Color.fromRGBO(255, 255, 255, 0.9),
        ],
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}

class TimeTableTheme {
  static double get timeTableColumnWidth {
    return 270;
  }

  static double get timeTableHourRowHeight {
    return 50;
  }

  // Returns the width of sidebar and height of topbar
  static List<double> get timeTableSideBarSizes {
    return [50.0, 50.0];
  }
}
