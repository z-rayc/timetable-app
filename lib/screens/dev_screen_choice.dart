import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/texts/label.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';
import 'package:timetable_app/widgets/texts/title.dart';

class DevScreenChoice extends StatelessWidget {
  const DevScreenChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = kSupabase.auth;
    final edge = kSupabase.functions;
    return Scaffold(
      appBar: AppBar(
        title: const CTitle("Dev Screen Choice"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CSubtitle(
                  'This screen is only for development purposes. Chosen screen will be pushed on top of nav s tack.'),
              ...NavState.values
                  .where((identifier) => identifier != NavState.devScreenChoice)
                  .map(
                    (screenIdentifier) => ElevatedButton(
                      style: AppThemes.entrySecondaryButtonTheme,
                      onPressed: () {
                        pushNewScreen(context, screenIdentifier);
                      },
                      child: CLabel(screenIdentifier.name),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 100),
              ElevatedButton(
                style: AppThemes.entrySecondaryButtonTheme,
                onPressed: () {
                  log('Session token: ${auth.currentSession}');
                },
                child: const CLabel('Print session token to console'),
              ),
              ElevatedButton(
                style: AppThemes.entrySecondaryButtonTheme,
                onPressed: () {
                  edge
                      .invoke('getCourseEvents', body: {
                        'id': 'IDATA2502',
                      })
                      .whenComplete(() => log('Edge function called'))
                      .catchError(
                          (error) => log('Edge function error: $error'));
                },
                child: const CLabel('Call edge function to populate events'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
