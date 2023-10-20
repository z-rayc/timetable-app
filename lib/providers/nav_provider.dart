import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/screens/splash_screen.dart';

enum NavProviderState {
  splashScreen(SplashScreen());
  // timetable,
  // login,
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

  const NavProviderState(this.screen);
  final Widget screen;
}

class NavProviderNotifier extends StateNotifier<NavProviderState> {
  NavProviderNotifier() : super(NavProviderState.splashScreen);

  void setNavState(NavProviderState state) {
    state = state;
  }
}

final navProvider =
    StateNotifierProvider<NavProviderNotifier, NavProviderState>(
  (ref) => NavProviderNotifier(),
);
