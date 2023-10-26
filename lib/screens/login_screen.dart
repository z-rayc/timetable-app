import 'package:flutter/material.dart';
import 'package:timetable_app/app_theme.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/login_screen/single_sign_on_button.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
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
                    print('Feide sign in');
                  },
                ),
                SingleSignOnButton(
                  providerLogoAsset: 'assets/images/google-logo.svg',
                  logoSemanticLabel: 'Google logo',
                  onPressed: () {
                    print('Google sign in');
                  },
                ),
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
