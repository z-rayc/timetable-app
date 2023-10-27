import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/screens/account_settings.dart';
import 'package:timetable_app/screens/course_details_screen.dart';
import 'package:timetable_app/screens/dev_screen_choice.dart';
import 'package:timetable_app/screens/login_email_screen.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/screens/register_screen.dart';
import 'package:timetable_app/screens/select_courses_screen.dart';
import 'package:timetable_app/screens/splash_screen.dart';

enum NavState {
  splash(SplashScreen()),
  // timetable,

  login(LoginScreen()),
  loginEmail(LoginEmailScreen()),
  register(RegisterScreen()),
  selectCourses(SelectCoursesScreen()),

  // dayPlan,
  // eventDetails,
  courseDetails(CourseDetailsScreen()),
  // chat,
  // chatList,
  // accountPage,
  settings(AccountSettings()),
  // myCourses,
  devScreenChoice(DevScreenChoice());

  const NavState(this.screen);
  final Widget screen;
}

class NavProviderNotifier extends ChangeNotifier {
  late Widget _currentScreen =
      const DevScreenChoice(); // TODO change to splash when stuff is ready
  Widget get currentScreen => _currentScreen;

  setCurrentScreen(NavState newScreen) {
    _currentScreen = newScreen.screen;
    notifyListeners();
  }
}

final navProvider = ChangeNotifierProvider<NavProviderNotifier>(
  (ref) => NavProviderNotifier(),
);

/// Pushes a new screen onto the navigation stack using the [NavState] enum.
pushNewScreen(BuildContext context, NavState newScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => newScreen.screen),
  );
}
