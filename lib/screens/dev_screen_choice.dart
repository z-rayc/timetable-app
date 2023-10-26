import 'package:flutter/material.dart';
import 'package:timetable_app/app_theme.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class DevScreenChoice extends StatelessWidget {
  const DevScreenChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dev Screen Choice"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('This screen is only for development purposes.'),
              const Text('Chosen screen will be pushed on top of nav s tack.'),
              ...NavState.values
                  .where((identifier) => identifier != NavState.devScreenChoice)
                  .map(
                    (screenIdentifier) => ElevatedButton(
                      style: AppThemes.entrySecondaryButtonTheme,
                      onPressed: () {
                        pushNewScreen(context, screenIdentifier);
                      },
                      child: Text(screenIdentifier.name),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
