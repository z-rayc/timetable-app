import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
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

  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredConfirmPassword = '';

  final TextEditingController _passwordController = TextEditingController();

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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

// const EdgeInsets.only(left: 70, right: 70, top: 20),
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
                        onPressed: _sublitForm,
                        style: AppThemes.entryButtonTheme,
                        child: const Text('Register'),
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
