import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/primary_elevated_button_loading_child.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Email login screen widget. Displays a form to sign in with email.
/// Also displays a button to register a new account.
class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginEmailScreenState();
  }
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool _loading = false;

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _setLoading(true);
      try {
        await kSupabase.auth
            .signInWithPassword(
                password: _enteredPassword, email: _enteredEmail)
            .timeout(kDefaultTimeout);

        if (context.mounted) {
          popAllScreens(context);
        }
      } on AuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        }
      } on TimeoutException {
        _showTimeoutSnackbar();
      } finally {
        _setLoading(false);
      }
    }
  }

  void _showTimeoutSnackbar() {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.requestTimedOut),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    Widget signInForm = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.email),
          ShadowedTextFormField(
            child: TextFormField(
              decoration: AppThemes.entryFieldTheme,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.plsEnterEmail;
                } else if (!value.contains('@')) {
                  return AppLocalizations.of(context)!.plsEnterValidEmail;
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                _enteredEmail = newValue!;
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.password),
          ShadowedTextFormField(
            child: TextFormField(
              decoration: AppThemes.entryFieldTheme,
              obscureText: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.plsEnterPassword;
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                _enteredPassword = newValue!;
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitForm,
                  style: AppThemes.entryButtonTheme,
                  child: _loading
                      ? const PrimaryElevatedButtonLoadingChild()
                      : Text(AppLocalizations.of(context)!.signIn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    var noAccountButton = Column(
      children: [
        Text(AppLocalizations.of(context)!.noAccount),
        ElevatedButton(
          onPressed: () {
            pushNewScreen(context, NavState.register);
          },
          style: AppThemes.entrySecondaryButtonTheme,
          child: Text(AppLocalizations.of(context)!.register),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signInWithEmail),
      ),
      body: !isWideScreen
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 70, right: 70, top: 20, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [signInForm, const Spacer(), noAccountButton],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 150, right: 150, top: 0, bottom: 40),
                child: Column(
                  children: [
                    signInForm,
                    const SizedBox(height: 20),
                    noAccountButton,
                  ],
                ),
              ),
            ),
    );
  }
}
