import 'package:flutter/material.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        kSupabase.auth.signOut();
        popAllScreens(context);
      },
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
    );
  }
}
