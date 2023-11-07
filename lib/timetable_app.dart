import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/screens/splash_screen.dart';
import 'package:timetable_app/screens/tabs_screen.dart';

class TimeTableApp extends ConsumerStatefulWidget {
  const TimeTableApp({super.key});
  @override
  ConsumerState<TimeTableApp> createState() {
    return _TimeTableAppState();
  }
}

class _TimeTableAppState extends ConsumerState<TimeTableApp> {
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.session != null) {
        ref.read(navProvider.notifier).setCurrentScreen(NavState.tabs);
      } else {
        ref.read(navProvider.notifier).setCurrentScreen(NavState.login);
      }
    });
    super.initState();
    _doInitialSetup();
  }

  void _doInitialSetup() async {
    await Future.delayed(Duration.zero);
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      ref.read(navProvider.notifier).setCurrentScreen(NavState.tabs);
    } else {
      ref.read(navProvider.notifier).setCurrentScreen(NavState.login);
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navProvider);

    return MaterialApp(
      theme: AppThemes.theme,
      home: Consumer(
        builder: (context, ref, child) {
          return navState.currentScreen;
        },
      ),
    );
  }
}
