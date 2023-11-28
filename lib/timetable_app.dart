import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetable_app/providers/setting_provider.dart';

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
    _authStateSubscription = kSupabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      _setScreenFromSession(session);
    });
    super.initState();
    _doInitialSetup();
  }

  void _doInitialSetup() async {
    await Future.delayed(Duration.zero);
    final session = kSupabase.auth.currentSession;
    _setScreenFromSession(session);
  }

  void _setScreenFromSession(Session? session) {
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
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemes.theme,
      home: Consumer(
        builder: (context, ref, child) {
          return navState.currentScreen;
        },
      ),
      locale: settings.when(data: (AppSettings data) {
        log(data.language.shortName);
        return Locale(data.language.shortName);
      }, loading: () {
        return const Locale('nb');
      }, error: (err, stack) {
        log(err.toString());
        return const Locale('nb');
      }),
    );
  }
}
