import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/widgets/login_screen/single_sign_on_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _googleSignIn() async {
    _setLoading(true);

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

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const UserAbortSigninException();
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final response = await kSupabase.auth
          .signInWithIdToken(
            provider: Provider.google,
            idToken: idToken,
            accessToken: accessToken,
          )
          .timeout(kDefaultTimeout);
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } on UserAbortSigninException {
      // do nothing
    } catch (e) {
      _showErrorSnackBar('Something went wrong. Please try again later.');
    } finally {
      _setLoading(false);
      //unfocus the google overlay
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _showErrorSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppThemes.theme.colorScheme.error,
        ),
      );
    }
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
                const Spacer(flex: 5),
                SingleSignOnButton(
                  providerLogoAsset: 'assets/images/Horisontal_Feide.svg',
                  logoSemanticLabel: 'Feide logo',
                  onPressed: _isLoading
                      ? null
                      : () {
                          _showAlertDialog(context, 'Feide sign in');
                        },
                ),
                SingleSignOnButton(
                  providerLogoAsset: 'assets/images/google-logo.svg',
                  logoSemanticLabel: 'Google logo',
                  onPressed: _isLoading ? null : _googleSignIn,
                ),
                const SizedBox(height: 8),
                if (_isLoading)
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                          color: AppThemes.theme.colorScheme.secondary)),
                if (!_isLoading) const SizedBox(height: 40),
                const Spacer(flex: 4),
                ElevatedButton(
                  style: AppThemes.entrySecondaryButtonTheme,
                  onPressed: _isLoading
                      ? null
                      : () {
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

class UserAbortSigninException implements Exception {
  const UserAbortSigninException();
}