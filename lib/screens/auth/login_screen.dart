import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/widgets/login_screen/single_sign_on_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '683060048034-qu3vcsn6pnqam9jupco7uq1bjkukjluv.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '683060048034-v6ctb2aap3nn0kkfk4dmr7bumpl2ok70.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      final response = await kSupabase.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on AuthException catch (e) {
    } catch (e) {}
  }

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
                  onPressed: _googleSignIn,
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
