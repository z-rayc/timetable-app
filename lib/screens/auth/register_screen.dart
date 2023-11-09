import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/primary_elevated_button_loading_child.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';

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

      _setLoading(true);
      try {
        // response contains the user information, can be used in a provider
        // ignore: unused_local_variable
        final response = await kSupabase.auth
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
        const SnackBar(
          content: Text('Request timed out.'),
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
      appBar: AppBar(title: const Text('Register with email')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 70, right: 70, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Email'),
                ShadowedTextFormField(
                  child: TextFormField(
                    decoration: AppThemes.entryFieldTheme,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
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
                const Text('Password'),
                ShadowedTextFormField(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: AppThemes.entryFieldTheme,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      } else if (value.trim().length < 6) {
                        return 'Password too short';
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
                const Text('Confirm Password'),
                ShadowedTextFormField(
                  child: TextFormField(
                    decoration: AppThemes.entryFieldTheme,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match!';
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
                            : const Text('Register'),
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
