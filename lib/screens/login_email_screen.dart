import 'package:flutter/material.dart';
import 'package:timetable_app/app_theme.dart';

class LoginEmailScreen extends StatelessWidget {
  LoginEmailScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login With Email"),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Sign in'),
                  TextFormField(
                    decoration: AppThemes.entryFieldTheme.copyWith(),
                  ),
                  const SizedBox(height: 20),
                  const Text('Password'),
                  TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith()),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: AppThemes.entryButtonTheme,
                          child: const Text('Sign in'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
