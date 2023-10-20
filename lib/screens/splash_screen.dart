import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Splash Screen"),
      ),
      drawer: const NavDrawer(),
      body: Center(
          child: TextButton(
        child: const Text("Press me to change screen"),
        onPressed: () {
          navState.setCurrentScreen(NavState.login);
        },
      )),
    );
  }
}
