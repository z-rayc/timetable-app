import 'package:flutter/material.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      label: Text(AppLocalizations.of(context)!.logout),
    );
  }
}
