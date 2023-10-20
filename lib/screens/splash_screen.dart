import 'package:flutter/material.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Splash Screen"),
      ),
      drawer: const NavDrawer(),
      body: Center(
          child: TextButton(
        child: const Text("Press me to change screen"),
        onPressed: () {},
      )),
    );
  }
}
