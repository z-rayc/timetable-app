import 'package:flutter/material.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      drawer: const NavDrawer(),
      body: const Text('Hello World!'),
    );
  }
}
