import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/widgets/login_screen/single_sign_on_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  _showAlertDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content:
                  const Text('Not implemented yet. Please use another option.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: splashBackgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SingleSignOnButton(
                  providerLogoAsset: 'assets/images/Horisontal_Feide.svg',
                  logoSemanticLabel: 'Feide logo',
                  onPressed: () {
                    _showAlertDialog(context, 'Feide sign in');
                  },
                ),
                SingleSignOnButton(
                    providerLogoAsset: 'assets/images/google-logo.svg',
                    logoSemanticLabel: 'Google logo',
                    onPressed: () {
                      // _showAlertDialog(context, 'Google sign in');
                      kSupabase.auth.signInWithOAuth(Provider.google);
                    }),
                const Spacer(),
                ElevatedButton(
                  style: AppThemes.entrySecondaryButtonTheme,
                  onPressed: () {
                    pushNewScreen(context, NavState.loginEmail);
                  },
                  child: const Text('Email sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
