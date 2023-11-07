import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Use the settings provider to get the current settings

              Column(
                children: [
                  SwitchListTile(
                    title: const Text("Dark Mode?"),
                    value: settings.isDarkMode,
                    onChanged: (newValue) {
                      ref
                          .read(appSettingsProvider.notifier)
                          .setIsDarkMode(newValue);
                    },
                  ),
                  SwitchListTile(
                    title: const Text("Notifications"),
                    value: settings.isNotificationsEnabled,
                    onChanged: (newValue) {
                      ref
                          .read(appSettingsProvider.notifier)
                          .setIsNotificationsEnabled(newValue);
                    },
                  ),

                  // Language selector
                  ListTile(
                    title: const Text("Language"),
                    trailing: DropdownButton<Language>(
                      value: settings.language,
                      onChanged: (Language? newValue) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setLanguage(newValue!);
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
                        Supabase.instance.client.auth.signOut();
                        popAllScreens(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
