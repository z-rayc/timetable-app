import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // print('Email: $_enteredEmail');
      // print('Password: $_enteredPassword');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
      Supabase.instance.client.auth
          .signInWithPassword(password: _enteredPassword, email: _enteredEmail);
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
                  onPressed: _submitForm,
                  style: AppThemes.entryButtonTheme,
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    var noAccountButton = Column(
      children: [
        const Text('No account?'),
        ElevatedButton(
          onPressed: () {
            pushNewScreen(context, NavState.register);
          },
          style: AppThemes.entrySecondaryButtonTheme,
          child: const Text('Register'),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign in with email"),
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
