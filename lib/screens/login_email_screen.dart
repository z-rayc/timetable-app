import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  String _enteredEmail = '';

  String _enteredPassword = '';

  void _sublitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // print('Email: $_enteredEmail');
      // print('Password: $_enteredPassword');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login With Email"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 70, right: 70, top: 20, bottom: 40),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Email'),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme,
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
                      decoration: AppThemes.entryFieldTheme,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
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
                          onPressed: _sublitForm,
                          style: AppThemes.entryButtonTheme,
                          child: const Text('Sign in'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text('No account?'),
            ElevatedButton(
              onPressed: () {
                pushNewScreen(context, NavState.register);
              },
              style: AppThemes.entryButtonTheme,
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
