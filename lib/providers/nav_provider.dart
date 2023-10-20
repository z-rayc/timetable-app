import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/screens/splash_screen.dart';

enum NavState {
  splash(SplashScreen()),
  // timetable,
  login(LoginScreen());
  // loginEmail,
  // selectCourses,
  // dayPlan,
  // eventDetails,
  // courseDetails,
  // register,
  // chat,
  // chatList,
  // accountPage,
  // settings,
  // myCourses;

  const NavState(this.screen);
  final Widget screen;
}

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
