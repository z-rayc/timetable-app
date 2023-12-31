import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/screens/account_settings_screen.dart';
import 'package:timetable_app/screens/chat/chats_overview_screen.dart';
import 'package:timetable_app/screens/events/create_event_screen.dart';
import 'package:timetable_app/screens/auth/login_email_screen.dart';
import 'package:timetable_app/screens/auth/login_screen.dart';
import 'package:timetable_app/screens/courses/my_courses_screen.dart';
import 'package:timetable_app/screens/auth/register_screen.dart';
import 'package:timetable_app/screens/courses/select_courses_screen.dart';
import 'package:timetable_app/screens/timetables/single_day_timetable.dart';
import 'package:timetable_app/screens/auth/splash_screen.dart';
import 'package:timetable_app/screens/tabs_screen.dart';

/// This file has navigation provider as well as some helper functions for navigation.

/// Enum for all screens in the app. Screens requiring a parameter cannot be included here.
enum NavState {
  splash(SplashScreen()),
  singleDayTimetable(SingleDayTimetable()),
  login(LoginScreen()),
  loginEmail(LoginEmailScreen()),
  register(RegisterScreen()),
  selectCourses(SelectCoursesScreen()),
  createEvent(CreateEventScreen()),
  chats(ChatsOverviewScreen()),
  accountSettings(AccountSettingsScreen()),
  myCourses(MyCoursesScreen()),
  tabs(TabsScreen());

  const NavState(this.screen);
  final Widget screen;
}

/// A provider that switches screens based with the [NavState] enum.
class NavProviderNotifier extends ChangeNotifier {
  late Widget _currentScreen = const SplashScreen();
  Widget get currentScreen => _currentScreen;

  setCurrentScreen(NavState newScreen) {
    _currentScreen = newScreen.screen;
    notifyListeners();
  }
}

final navProvider = ChangeNotifierProvider<NavProviderNotifier>(
  (ref) => NavProviderNotifier(),
);

/// Pushes a new screen onto the navigation stack, where the new screen matches the [NavState] enum.
pushNewScreen(BuildContext context, NavState newScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => newScreen.screen),
  );
}

/// Replaces the current screen with a new screen in the navigation stack, where the new screen matches the [NavState] enum.
replaceNewScreen(BuildContext context, NavState newScreen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => newScreen.screen),
  );
}

/// Pops all screens from the navigation stack.
/// Call when you need to clear the stack, e.g. when logging in or out.
popAllScreens(BuildContext context) {
  while (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
