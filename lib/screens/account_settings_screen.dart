import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/providers/setting_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
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
                      title:
                          Text(AppLocalizations.of(context)!.settingsLanguage),
                      trailing: DropdownButton<Language>(
                        value: settings.asData!.value.language,
                        onChanged: (Language? newValue) {
                          ref
                              .read(appSettingsProvider.notifier)
                              .setLanguage(newValue!)
                              .whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .languageChanged)));

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
                        label: Text(AppLocalizations.of(context)!.logout))
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
