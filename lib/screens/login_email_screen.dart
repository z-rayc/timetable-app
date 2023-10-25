import 'package:flutter/material.dart';

class LoginEmailScreen extends StatelessWidget {
  const LoginEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login Email Screen"),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Go back"),
            ),
          ],
        ),
      ),
    );
  }
}
