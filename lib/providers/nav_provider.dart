import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/screens/account_settings_screen.dart';
import 'package:timetable_app/screens/chats_screen.dart';
import 'package:timetable_app/screens/course_details_screen.dart';
import 'package:timetable_app/screens/dev_screen_choice.dart';
import 'package:timetable_app/screens/event_details_screen.dart';
import 'package:timetable_app/screens/login_email_screen.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/screens/my_courses_screen.dart';
import 'package:timetable_app/screens/register_screen.dart';
import 'package:timetable_app/screens/select_courses_screen.dart';
import 'package:timetable_app/screens/single_day_timetable.dart';
import 'package:timetable_app/screens/splash_screen.dart';
import 'package:timetable_app/screens/tabs_screen.dart';
import 'package:timetable_app/screens/temp_timetable_screen.dart';

enum NavState {
  splash(SplashScreen()),
  timetable(SingleDayTimetable()),
  temptimetable(TempTimetableScreen()),
  login(LoginScreen()),
  loginEmail(LoginEmailScreen()),
  register(RegisterScreen()),
  selectCourses(SelectCoursesScreen()),

  // dayPlan,
  eventDetails(EventDetailsScreen()),
  courseDetails(CourseDetailsScreen()),
  // chat,
  chatsScreen(ChatsScreen()),
  // accountPage,
  accountSettingsScreen(AccountSettingsScreen()),
  myCoursesScreen(MyCoursesScreen()),
  tabsScreen(TabsScreen()),
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
