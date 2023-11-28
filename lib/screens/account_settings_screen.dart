import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/providers/setting_provider.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: settings.when(data: (AppSettings data) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Use the settings provider to get the current settings

                Column(
                  children: [
                    // Language selector
                    ListTile(
                      title: const Text("Language"),
                      trailing: DropdownButton<Language>(
                        value: settings.asData!.value.language,
                        onChanged: (Language? newValue) {
                          ref
                              .read(appSettingsProvider.notifier)
                              .setLanguage(newValue!)
                              .whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Language changed")));

                            ref.invalidate(appSettingsProvider);
                          });
                        },
                        items: Language.values
                            .map<DropdownMenuItem<Language>>(
                                (Language value) => DropdownMenuItem<Language>(
                                      value: value,
                                      child: Text(value.name),
                                    ))
                            .toList(),
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          kSupabase.auth.signOut();
                          popAllScreens(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'))
                  ],
                )
              ],
            ),
          ),
        );
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }, error: (Object error, StackTrace stackTrace) {
        log("Error: $error, $stackTrace");
        return const Center(child: Text("Error loading settingsS"));
      }),
    );
  }
}
