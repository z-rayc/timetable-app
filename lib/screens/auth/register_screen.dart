import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/primary_elevated_button_loading_child.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Register with email screen widget. Displays a form to register a new account with email.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String _enteredEmail = '';
  String _enteredPassword = '';
  // ignore: unused_field
  String _enteredConfirmPassword = '';
  final TextEditingController _passwordController = TextEditingController();

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
            .signUp(password: _enteredPassword, email: _enteredEmail)
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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.registerWithEmail)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 70, right: 70, top: 20),
          child: Form(
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
                    controller: _passwordController,
                    decoration: AppThemes.entryFieldTheme,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.plsEnterPassword;
                      } else if (value.trim().length < 6) {
                        return AppLocalizations.of(context)!.passwordTooShort;
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
                Text(AppLocalizations.of(context)!.confirmPassword),
                ShadowedTextFormField(
                  child: TextFormField(
                    decoration: AppThemes.entryFieldTheme,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.plsConfirmPassword;
                      } else if (value != _passwordController.text) {
                        return AppLocalizations.of(context)!.passwordsDontMatch;
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      _enteredConfirmPassword = newValue!;
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
                            : Text(AppLocalizations.of(context)!.register),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
